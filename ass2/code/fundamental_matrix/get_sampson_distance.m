function [ d ] = get_sampson_distance( F, p1, p2)
    % todo
    numerator = (p2'*F*p1).^2;
    
    temp_fp = F*p1;
    dt1 = temp_fp(1).^2;
    dt2 = temp_fp(2).^2;
    temp_fpp = F'*p2;
    dt3 = temp_fpp(1).^2;
    dt4 = temp_fpp(2).^2;
    denumerator = dt1 + dt2 + dt3 + dt4;
    
    d = numerator / denumerator;
end

