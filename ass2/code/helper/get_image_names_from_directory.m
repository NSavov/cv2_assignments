function [ f_names ] = get_image_names_from_directory( directory, ext )
    % todo
    struct = dir(strcat(directory, '*.', ext));
    f_names = {struct.name};
    f_names = strcat({directory}, f_names);
end

