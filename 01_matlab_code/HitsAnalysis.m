%% �˽ű��ļ���Ҫ���ڷ����Ƽ����˵���Ŀ���û��ۿ����Ľ�Ŀ�Ĺ�����ϵ
% ����һ�±���
slCharacterEncoding('UTF-8')

%% ��������ļ�
hitsfile = 'E:\record\temprecord\items_hits.txt';% ÿ���û��Ƽ����˵�item����
topnfile = 'E:\record\temprecord\items_top3.txt';% ��ÿ���û��Ƽ���top3 item����
trainfile = 'E:\record\temprecord\items_trains.txt';% ÿ���û�ѵ�����е�item����
outputfile = 'E:\record\temprecord\hits_trains.txt';% �ȽϽ������ļ�

%% ��������
fp = fopen(hitsfile);
hits = textscan(fp, '%d%s','delimiter', '\t');
fclose(fp);
hits_items = [hits{2}];% �õ�ÿ���û����Ƽ����е�item�����ַ�������

fp = fopen(topnfile);
topn = textscan(fp, '%d%s','delimiter', '\t');
fclose(fp);
topn_items = [topn{2}];% �õ�ÿ���û���topn�Ƽ�����item�����ַ�������

fp = fopen(trainfile);
trains = textscan(fp, '%d%s','delimiter', '\t');
fclose(fp);
trains_items = [trains{2}];% �õ�ÿ���û���ѵ�����е�item�����ַ�������

userID = hits{1};% �û���ID

%% ���ԱȽ��д������ļ�
fp = fopen(outputfile,'w');
usernum = length(userID);
for i=1:usernum
    trains_str = strrep(trains_items{i},',',' | ');
    topn_str = strrep(topn_items{i},',',' | ');
    hits_str = strrep(hits_items{i},',',' | ');
    fprintf(fp, '�û�ID��%d\n', userID(i));
    fprintf(fp, '�ۿ����Ľ�Ŀ��%s\n', trains_str);
    fprintf(fp, 'top 3 �Ƽ�����%s\n', topn_str);
    fprintf(fp, '�Ƽ��еĽ�Ŀ��%s\n\n', hits_str);
end
fclose(fp);

