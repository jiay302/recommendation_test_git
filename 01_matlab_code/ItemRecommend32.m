%% �˳������ڼ�������ά��Ϊ32�Ľڵ������ƶȣ��������ƶȴ���0�ļ�¼�����ָ���ļ�
clear;%�������
%% �����ı��ļ��е����ݡ�
% ��ʼ��������
filename = 'E:\record\temprecord\vec_1st_32.txt';
delimiter = ' ';

% ÿ���ı��еĸ�ʽ:
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

% ���ı��ļ���
fileID = fopen(filename,'r');

% ���ݸ�ʽ��ȡ�����С�
% �õ��û������ɴ˴������õ��ļ��Ľṹ����������ļ����ִ����볢��ͨ�����빤���������ɴ��롣
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);

% �ر��ı��ļ���
fclose(fileID);

% �����������
nodevec = [dataArray{1:end-1}];
% �����ʱ����
clearvars filename delimiter formatSpec fileID dataArray ans;

%% �������ƶȲ��������������������
%% 01movielens-2k
%usernum = 393;%�û���
%itemnum = 3261;%��Ʒ��
%% 02lastfm
%usernum = 1829;%�û���
%itemnum = 13875;%��Ʒ��
%% 01movielens-2k1
%usernum = 1867;%�û���
%itemnum = 5775;%��Ʒ��
%itemnum = 5762;%��Ʒ��
%itemnum = 5774;%��Ʒ��
%% 03userbehavior
usernum = 107086;%�û���
itemnum = 14749;%��Ʒ��

dimension = 33;%����ά��
% ���õ������������յ�һ�е�Ԫ�أ�������ID���������У��Ӷ����Vu��Vi���Եľ���
UserItemVec = sortrows(nodevec,1);
% ���ε�userID���Ϊusernum����Ӧ�����ǰusernum�У� itemID��usernum+1�п�ʼ
Vu = UserItemVec(1:usernum,:);
Vi = UserItemVec(usernum+1:usernum+itemnum,:);
outputfile = 'E:\record\temprecord\score_1st_32.txt';
fp = fopen(outputfile,'w');%��������ĵ÷ֺ���Ӧ��userID itemIDд���ļ���
for i=1:usernum
    userID = Vu(i,1);
    for j=1:itemnum
        itemID = Vi(j,1);
        score = dot(Vu(i,2:dimension),Vi(j,2:dimension));
        if score>0.2
            fprintf(fp, '%d\t%d\t%f\n', userID,itemID,score);
        end
    end
end
fclose(fp);

