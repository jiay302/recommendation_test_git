%% �˽ű��ļ���Ҫ���ڷ����Ƽ�һ����û�е��û����Ƽ���Ŀ���û��ۿ����Ľ�Ŀ�Ĺ�����ϵ
% ����һ�±���
slCharacterEncoding('UTF-8')

%% ��������ļ�
topnfile = 'E:\record\temprecord\items_nohits_top3.txt';% ��ÿ���û��Ƽ���top3 item����
trainfile = 'E:\record\temprecord\items_nohits_trains.txt';% ÿ���û�ѵ�����е�item����
testfile = 'E:\record\temprecord\items_nohits_tests.txt';% ÿ���û����Լ��е�item����
outputfile = 'E:\record\temprecord\nohits_trains.txt';% �ȽϽ������ļ�

%% ��������
fp = fopen(topnfile);
topn = textscan(fp, '%d%s','delimiter', '\t');
fclose(fp);
topn_items = [topn{2}];% �õ�ÿ���û���topn�Ƽ�����item�����ַ�������

fp = fopen(trainfile);
trains = textscan(fp, '%d%s','delimiter', '\t');
fclose(fp);
trains_items = [trains{2}];% �õ�ÿ���û���ѵ�����е�item�����ַ�������

fp = fopen(testfile);
tests = textscan(fp, '%d%s','delimiter', '\t');
fclose(fp);
tests_items = [tests{2}];% �õ�ÿ���û��Ĳ��Լ��е�item�����ַ�������

userID = topn{1};% �û���ID

%% ���ԱȽ��д������ļ�
fp = fopen(outputfile,'w');
usernum = length(userID);
for i=1:usernum
    trains_str = strrep(trains_items{i},',',' | ');
    tests_str = strrep(tests_items{i},',',' | ');
    topn_str = strrep(topn_items{i},',',' | ');
    fprintf(fp, '�û�ID��%d\n', userID(i));
    fprintf(fp, '�ۿ����Ľ�Ŀ��%s\n', trains_str);
    fprintf(fp, 'top 3 �Ƽ�����%s\n', topn_str);
    fprintf(fp, '�Ƽ��еĽ�Ŀ����\n');
    fprintf(fp, '���Լ��Ľ�Ŀ��%s\n\n', tests_str);
end
fclose(fp);

