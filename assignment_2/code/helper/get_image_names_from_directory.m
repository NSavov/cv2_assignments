function [ f_names ] = get_image_names_from_directory( directory, ext )
    % get all files with [ext] in a specific [directory]
    struct = dir(strcat(directory, '*.', ext));
    f_names = {struct.name};
    f_names = strcat({directory}, f_names);
end

