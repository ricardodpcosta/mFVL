% October, 2016
% get new code for mfvl_point1d
function res=mfvl_new_point1d_code()
persistent mfvl_point1d_code;
if(isempty(mfvl_point1d_code))
    mfvl_point1d_code=1;
end
res=mfvl_point1d_code;
mfvl_point1d_code=mfvl_point1d_code+1;
end
% end of file