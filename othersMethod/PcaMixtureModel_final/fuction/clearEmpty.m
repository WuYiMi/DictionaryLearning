function  arr  = clearEmpty( arr )
%CLEAREMPTY ��ȥ����/�����е�ȫ���к���
%   �˴���ʾ��ϸ˵��
arr(all(arr==0,2),:)=[]; %ȥ��ȫ����
arr(:,all(arr==0,1))=[]; %ȥ��ȫ����

end

