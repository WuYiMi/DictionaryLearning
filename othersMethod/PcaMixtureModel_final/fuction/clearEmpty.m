function  arr  = clearEmpty( arr )
%CLEAREMPTY 除去矩阵/数组中的全零行和列
%   此处显示详细说明
arr(all(arr==0,2),:)=[]; %去掉全零行
arr(:,all(arr==0,1))=[]; %去掉全零列

end

