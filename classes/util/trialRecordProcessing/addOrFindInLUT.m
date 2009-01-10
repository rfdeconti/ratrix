function [indices LUT] = addOrFindInLUT(LUT, fields)
% this function takes in an existing LUT and fields, both as cell arrays
% and tries to find each element in fields in the LUT.
% if the field does not exist in LUT, then it is added to the LUT
% returns the updated LUT, and indices, which is an array of the same size as fields that contains the index for each element in fields
% whether or not it was added.

indices=zeros(1,length(fields));
for i=1:length(fields)
    result=find(strcmp(LUT,fields{i}));
    if isempty(result) % did not find in LUT - ADD
        LUT{end+1} = fields{i};
        result=length(LUT);
    end
    indices(i)=result;
end

end % end function