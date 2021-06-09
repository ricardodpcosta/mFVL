% November, 2016
% get new code for mfvl_material1d
function res=mfvl_new_material1d_code()
persistent mfvl_material1d_code;
if(isempty(mfvl_material1d_code))
    mfvl_material1d_code=6001;
end
res=mfvl_material1d_code;
mfvl_material1d_code=mfvl_material1d_code+1;
end
% end of file