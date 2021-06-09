% October, 2016
% get new code for line1d
function res=mfvl_new_line1d_code()
persistent mfvl_line1d_code;
if(isempty(mfvl_line1d_code))
    mfvl_line1d_code=1001;
end
res=mfvl_line1d_code;
mfvl_line1d_code=mfvl_line1d_code+1;
end
% end of file