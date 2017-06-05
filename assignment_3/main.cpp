/*
 * main.cpp
 *
 *  Created on: 28 May 2016
 *      Author: Minh Ngo @ 3DUniversum
 */
#include <iostream>
#include <boost/format.hpp>
#include <vector>
#include <cmath>
#include <limits>
#include <numeric>

#include <pcl/point_types.h>
#include <pcl/point_cloud.h>
#include <pcl/features/integral_image_normal.h>
#include <pcl/visualization/pcl_visualizer.h>
#include <pcl/visualization/cloud_viewer.h>
#include <pcl/common/transforms.h>
#include <pcl/kdtree/kdtree_flann.h>
#include <pcl/filters/passthrough.h>
#include <pcl/surface/poisson.h>
#include <pcl/surface/impl/texture_mapping.hpp>
#include <pcl/features/normal_3d_omp.h>
#include <pcl/surface/marching_cubes_hoppe.h>
#include <pcl/surface/marching_cubes_rbf.h>
#include <pcl/surface/marching_cubes.h>
#include <pcl/surface/poisson.h>
#include <pcl/PolygonMesh.h>
#include <pcl/surface/texture_mapping.h>
#include <pcl/io/vtk_lib_io.h>
#include <pcl/console/parse.h>

#include <eigen3/Eigen/Core>

#include <opencv2/opencv.hpp>
#include <opencv2/core/mat.hpp>
#include <opencv2/core/eigen.hpp>
    
#include "Frame3D/Frame3D.h"
using namespace std;
using namespace pcl;

pcl::PointCloud<pcl::PointXYZ>::Ptr mat2IntegralPointCloud(const cv::Mat& depth_mat, const float focal_length, const float max_depth) {
    // This function converts a depth image to a point cloud
    assert(depth_mat.type() == CV_16U);
    pcl::PointCloud<pcl::PointXYZ>::Ptr point_cloud(new pcl::PointCloud<pcl::PointXYZ>());
    const int half_width = depth_mat.cols / 2;
    const int half_height = depth_mat.rows / 2;
    const float inv_focal_length = 1.0 / focal_length;
    point_cloud->points.reserve(depth_mat.rows * depth_mat.cols);
    for (int y = 0; y < depth_mat.rows; y++) {
        for (int x = 0; x < depth_mat.cols; x++) {
            float z = depth_mat.at<ushort>(cv:: Point(x, y)) * 0.001;
            if (z < max_depth && z > 0) {
                point_cloud->points.emplace_back(static_cast<float>(x - half_width)  * z * inv_focal_length,
                                                 static_cast<float>(y - half_height) * z * inv_focal_length,
                                                 z);
            } else {
                point_cloud->points.emplace_back(x, y, NAN);
            }
        }
    }
    point_cloud->width = depth_mat.cols;
    point_cloud->height = depth_mat.rows;
    return point_cloud;
}


pcl::PointCloud<pcl::PointNormal>::Ptr computeNormals(pcl::PointCloud<pcl::PointXYZ>::Ptr cloud) {
    // This function computes normals given a point cloud
    // !! Please note that you should remove NaN values from the pointcloud after computing the surface normals.
    pcl::PointCloud<pcl::PointNormal>::Ptr cloud_normals(new pcl::PointCloud<pcl::PointNormal>); // Output datasets
    pcl::IntegralImageNormalEstimation<pcl::PointXYZ, pcl::PointNormal> ne;
    ne.setNormalEstimationMethod(ne.AVERAGE_3D_GRADIENT);
    ne.setMaxDepthChangeFactor(0.02f);
    ne.setNormalSmoothingSize(10.0f);
    ne.setInputCloud(cloud);
    ne.compute(*cloud_normals);
    pcl::copyPointCloud(*cloud, *cloud_normals);
    return cloud_normals;
}

pcl::PointCloud<pcl::PointXYZRGB>::Ptr transformPointCloud(pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud, const Eigen::Matrix4f& transform) {
    pcl::PointCloud<pcl::PointXYZRGB>::Ptr transformed_cloud(new pcl::PointCloud<pcl::PointXYZRGB>());
    pcl::transformPointCloud(*cloud, *transformed_cloud, transform);
    return transformed_cloud;
}


template<class T>
typename pcl::PointCloud<T>::Ptr transformPointCloudNormals(typename pcl::PointCloud<T>::Ptr cloud, const Eigen::Matrix4f& transform) {
    typename pcl::PointCloud<T>::Ptr transformed_cloud(new typename pcl::PointCloud<T>());
    pcl::transformPointCloudWithNormals(*cloud, *transformed_cloud, transform);
    return transformed_cloud;
}

void viewerOneOff (pcl::visualization::PCLVisualizer& viewer)
{
    viewer.setBackgroundColor (1.0, 1.0, 1.0);
}

pcl::PointCloud<pcl::PointNormal> build_full_cloud(Frame3D frames[])
{
    pcl::PointCloud<pcl::PointNormal> full_cloud;

    for (int i = 0; i < 8; ++i) {
        cv::Mat depth_image =  frames[i].depth_image_;
        double focal_length = frames[i].focal_length_;
        const Eigen::Matrix4f& camera_pose = frames[i].getEigenTransform();
        pcl::PointCloud<pcl::PointXYZ>::Ptr cloud = mat2IntegralPointCloud(depth_image, focal_length, 1);
        pcl::PointCloud<pcl::PointNormal>::Ptr cloud_normals = computeNormals(cloud);

        pcl::PointCloud<pcl::PointNormal>::Ptr transformed_cloud_normals =  transformPointCloudNormals<pcl::PointNormal>(cloud_normals,  camera_pose);

        full_cloud += *transformed_cloud_normals;
    }

    std::vector< int > index ;
    pcl::PointCloud<pcl::PointNormal> filtered_cloud_normals;
    pcl::removeNaNNormalsFromPointCloud(full_cloud, filtered_cloud_normals, index);

    return filtered_cloud_normals;
}

PolygonMesh reconstruct(pcl::PointCloud<pcl::PointNormal>::Ptr xyz_cloud)
{
    PolygonMesh mesh;

    Poisson<PointNormal> poisson;
    poisson.setDepth(8);
//    poisson.setIsoDivide(8);
    poisson.setSamplesPerNode (16);

    poisson.setInputCloud(xyz_cloud);
    poisson.reconstruct(mesh);
    return mesh;
}

struct UVPoint{
    float u;
    float v;
};

struct Color{

    Color()
    {
        this->b = 0;
        this->g = 0;
        this->r = 0;
    }

    Color(int b, int g, int r)
    {
        this->b = b;
        this->g = g;
        this->r = r;
    }

    int b;
    int g;
    int r;
};

int main(int argc, char *argv[]) {

    if (argc != 2)
        return 0;


    Frame3D frames[8];
    
    for (int i = 0; i < 8; ++i) {
        frames[i].load(boost::str(boost::format("%s/%05d.3df") % argv[1] % i));
    }

    pcl::PointCloud<pcl::PointNormal> full_cloud = build_full_cloud(frames);
    PointCloud<PointNormal>::Ptr xyz_cloud(&full_cloud);

//POISSON SURFACE RECONSTRUCTION
    PolygonMesh mesh = reconstruct(xyz_cloud);

    boost::shared_ptr<pcl::visualization::PCLVisualizer> viewer1(new pcl::visualization::PCLVisualizer("3D Viewer"));
    viewer1->setBackgroundColor(1, 1, 1);
    viewer1->addPolygonMesh(mesh, "meshes", 0);

    viewer1->setShapeRenderingProperties(pcl::visualization::PCL_VISUALIZER_SHADING,
                                        pcl::visualization::PCL_VISUALIZER_SHADING_PHONG, "meshes");
    viewer1->addCoordinateSystem(1.0);
    viewer1->initCameraParameters();

    while (!viewer1->wasStopped()) {
     viewer1->spinOnce(100);
     boost::this_thread::sleep(boost::posix_time::microseconds(100000));
    }

//COLORING

    std::vector< pcl::Vertices> polygons = mesh.polygons;

    PointCloud<PointXYZRGB> mesh_cloud;
    PointCloud<PointXYZRGB>::Ptr mesh_cloud_ptr(&mesh_cloud);
    pcl::fromPCLPointCloud2(mesh.cloud ,*mesh_cloud_ptr);

    vector<vector<Color>> colors(mesh_cloud_ptr->size());

    for (int i = 0; i < 8; ++i) {


        cv::Mat depth_image =  frames[i].depth_image_;

        int cx = depth_image.cols / 2;
        int cy = depth_image.rows / 2;

        cv::Mat rgb_image = frames[i].rgb_image_;

        int rgb_width = rgb_image.cols;
        int rgb_height = rgb_image.rows;




        double focal_length = frames[i].focal_length_;
        const Eigen::Matrix4f& camera_pose = frames[i].getEigenTransform().inverse();
        PointCloud<PointXYZRGB>::Ptr transformed_mesh_cloud_ptr =  transformPointCloud(mesh_cloud_ptr,  camera_pose);

        for(std::vector<pcl::Vertices>::iterator it = polygons.begin(); it != polygons.end(); ++it)
        {
            PointXYZRGB& pnt3 = (*transformed_mesh_cloud_ptr)[(*it).vertices[0]];
            PointXYZRGB& pnt2 = (*transformed_mesh_cloud_ptr)[(*it).vertices[1]];
            PointXYZRGB& pnt1 = (*transformed_mesh_cloud_ptr)[(*it).vertices[2]];

            pcl::PointXYZ pt3(pnt3.x, pnt3.y, pnt3.z);
            pcl::PointXYZ pt2(pnt2.x, pnt2.y, pnt2.z);
            pcl::PointXYZ pt1(pnt1.x, pnt1.y, pnt1.z);

            Eigen::Vector3f vec12(pt2.x-pt1.x,pt2.y-pt1.y,pt2.z-pt1.z);
            Eigen::Vector3f vec23(pt3.x-pt2.x,pt3.y-pt2.y,pt3.z-pt2.z);
            Eigen::Vector3f vecNorm = vec12.cross(vec23);
            vecNorm.normalize();

            double polygon_z = vecNorm[2];

            if(polygon_z > 0.3)
            {
                for(vector<uint32_t>::iterator index_it = (*it).vertices.begin(); index_it != (*it).vertices.end(); ++index_it)
                {
                    PointXYZRGB& point = (*transformed_mesh_cloud_ptr)[*index_it];

                    // Principal points
                    int u_unscaled = std::round(focal_length * (point.x / point.z) + cx);
                    int v_unscaled = std::round(focal_length * (point.y / point.z) + cy);

                    float u = static_cast<float>(float(u_unscaled) / depth_image.cols);
                    float v = static_cast<float>(float(v_unscaled) / depth_image.rows);
                    // Remember to check that u, v are in the range [0, 1)
                    if(u<0 || u>=1 || v<0 || v>=1)
                        continue;

                    /// Correspondent point in the RGB image
                    int x = int(std::floor(float(rgb_width) * u));
                    int y = int(std::floor(float(rgb_height) * v));

                  cv::Vec3b bgrPixel = rgb_image.at<cv::Vec3b>(y, x);
                  colors[*index_it].push_back(Color(bgrPixel.val[0],bgrPixel.val[1],bgrPixel.val[2]));

                }
            }
        }

    }


    for(int ind=0; ind<colors.size(); ++ind)
    {
        if(!colors[ind].empty())
        {
            //LAST OVERTAKING
//            Color color = colors[ind][colors[ind].size()-1];

            //AVERAGE


            sort(colors[ind].begin(), colors[ind].end(),
                [](const Color & a, const Color & b) -> bool
            {
                return a.b+a.g+a.r > b.b+b.g+b.r;
            });


            if(colors[ind].size()>1)
                colors[ind].erase(colors[ind].begin());

            Color averageColor;
            for(int c_ind=0; c_ind<colors[ind].size(); ++c_ind)
            {
                averageColor.b += colors[ind][c_ind].b;
                averageColor.g += colors[ind][c_ind].g;
                averageColor.r += colors[ind][c_ind].r;
            }

            averageColor.b /= colors[ind].size();
            averageColor.g /= colors[ind].size();
            averageColor.r /= colors[ind].size();

//            Color color = averageColor;

            //INTENSITY MEDIAN


            Color color;
            size_t size = colors[ind].size();

            if (size  % 2 == 0)
            {
//                color = colors[ind][size / 2];
                color.b = (colors[ind][size / 2 - 1].b + colors[ind][size / 2].b) / 2;
                color.g = (colors[ind][size / 2 - 1].g + colors[ind][size / 2].g) / 2;
                color.r = (colors[ind][size / 2 - 1].r + colors[ind][size / 2].r) / 2;
            }
            else
            {
                color = colors[ind][size / 2];
            }


//            color.b = ((float(color.b) / (color.b+color.g+color.r)) * (averageColor.b+averageColor.g+averageColor.r));
//            color.g = ((float(color.g) / (color.b+color.g+color.r)) * (averageColor.b+averageColor.g+averageColor.r));
//            color.r = ((float(color.r) / (color.b+color.g+color.r)) * (averageColor.b+averageColor.g+averageColor.r));


            (*mesh_cloud_ptr)[ind].b = color.b;
            (*mesh_cloud_ptr)[ind].g = color.g;
            (*mesh_cloud_ptr)[ind].r = color.r;
        }
    }



    std::cout << "Finished texturing" << std::endl;



//    pcl::visualization::CloudViewer pc_viewer ("Simple Cloud Viewer");

//    pc_viewer.showCloud (mesh_cloud_ptr);
//    pc_viewer.runOnVisualizationThreadOnce (viewerOneOff);
//    while (!pc_viewer.wasStopped ())
//    {
//    }

    pcl::toPCLPointCloud2(*mesh_cloud_ptr, mesh.cloud);
    boost::shared_ptr<pcl::visualization::PCLVisualizer> viewer(new pcl::visualization::PCLVisualizer("3D Viewer"));
    viewer->setBackgroundColor(1, 1, 1);
    viewer->addPolygonMesh(mesh, "meshes", 0);

    viewer->setShapeRenderingProperties(pcl::visualization::PCL_VISUALIZER_SHADING,
                                        pcl::visualization::PCL_VISUALIZER_SHADING_PHONG, "meshes");
    viewer->addCoordinateSystem(1.0);
    viewer->initCameraParameters();

    while (!viewer->wasStopped()) {
     viewer->spinOnce(100);
     boost::this_thread::sleep(boost::posix_time::microseconds(100000));
    }


    return 0;
}

//SCRAP CODE


/* TEXTURING:
 *
    cv::Size size = depth_image.size();
    int depth_width  = size.width;
    int depth_height  = size.height;


    int cx = depth_width / 2;
    int cy = depth_height / 2;

    cout<<cx<<' '<<cy<<endl;
//        int u_unscaled = std::round(focal_length * (point.x / point.z) + cx);
//        int v_unscaled = std::round(focal_length * (point.y / point.z) + cy);

//        float u = static_cast<float>(u_unscaled / sizeX);
//        float v = static_cast<float>(v_unscaled / sizeY);
*/

//CHECK FOR NANS

//    for(pcl::PointCloud<pcl::PointNormal>::iterator it = filtered_cloud_normals.begin(); it!= filtered_cloud_normals.end(); it++){
//    cout << it->x << ", " << it->y << ", " << it->z << endl;
//    }

//SCALING
//    int N = 100;
//    Eigen::Matrix4f transform = Eigen::Matrix4f::Identity();
//    transform (0,0) = transform (0,0) * N;
//    transform (1,1) = transform (1,1) * N;
//    transform (2,2) = transform (2,2) * N;
//    PointCloud<PointNormal>::Ptr full_cloud_ptr(&full_cloud);
//    PointCloud<PointNormal>::Ptr xyz_cloud = transformPointCloudNormals<PointNormal>(full_cloud_ptr, transform);

//SHOW XYZ POINTCLOUD
//    PointCloud<PointXYZRGB> cloud_xyzrgb;
//    copyPointCloud(*xyz_cloud, cloud_xyzrgb);

//    PointCloud<PointXYZRGB>::Ptr cloud_xyzrgb_ptr(&cloud_xyzrgb);

//    pcl::visualization::CloudViewer pc_viewer ("Simple Cloud Viewer");

//    pc_viewer.showCloud (cloud_xyzrgb_ptr);
//    pc_viewer.runOnVisualizationThreadOnce (viewerOneOff);
//    while (!pc_viewer.wasStopped ())
//    {
//    }


//MARCHING CUBES
//    float iso_level = 0.5f;
//     double leafSize = 0.01;
//    int hoppe_or_rbf = 0;
//    float extend_percentage = 0.0f;
//    int grid_res = 50;
//    float off_surface_displacement = 0.001f;

//    pcl::search::KdTree<PointNormal>::Ptr tree (new pcl::search::KdTree<PointNormal>);

//    MarchingCubes<PointNormal> *mc;
//    if (hoppe_or_rbf == 0)
//      mc = new MarchingCubesHoppe<PointNormal> ();
//    else
//    {
//      mc = new MarchingCubesRBF<PointNormal> ();
//      (reinterpret_cast<MarchingCubesRBF<PointNormal>*> (mc))->setOffSurfaceDisplacement (off_surface_displacement);
//    }

//    mc->setIsoLevel (iso_level);
//    mc->setGridResolution (grid_res, grid_res, grid_res);
//    mc->setPercentageExtendGrid (extend_percentage);
////    mc->setSearchMethod(tree);
//    mc->setInputCloud (xyz_cloud);

//     cout<<"Computing "<<endl;

//    mc->reconstruct (mesh);
//    delete mc;

//POISSON WITH MORE PARAMS

//    Poisson<PointNormal> poisson;
//    poisson.setDepth (depth);
//    poisson.setSolverDivide (solver_divide);
//    poisson.setIsoDivide (iso_divide);
//poisson.setPointWeight (point_weight);
//poisson.setInputCloud (xyz_cloud);

//cout<<"Computing ..."<<endl;
//poisson.reconstruct (mesh);
