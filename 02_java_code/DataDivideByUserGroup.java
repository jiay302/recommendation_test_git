package datahandler;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;

//此程序用于将数据集按用户分组划分为训练集和测试集（7:3）
public class DataDivideByUserGroup {
	
	static final String INPUTFILE = "E:\\record\\03userbehavior\\02datahandle\\dataInit.txt";
	static final String TRAININGFILE = "E:\\record\\03userbehavior\\02datahandle\\training.txt";
	static final String TESTINGFILE = "E:\\record\\03userbehavior\\02datahandle\\testing.txt";
	
	//01movielens-2k
//	static final int USER_ID = 393;//输入文件中用户的总数
//	static final int RATE_NUM = 368854;//输入文件中打分记录的总数
	
	//02lastfm
//	static final int USER_ID = 1829;//输入文件中用户的总数
//	static final int RATE_NUM = 91450;//输入文件中打分记录的总数
	
	//03userbehavior
	static final int USER_ID = 59176;//输入文件中用户的总数
	static final int RATE_NUM = 736583;//输入文件中打分记录的总数
	
	public static void creatTrainAndTest() throws FileNotFoundException, IOException {
		BufferedReader input = new BufferedReader(new FileReader(INPUTFILE));
		BufferedWriter training = new BufferedWriter(new FileWriter(TRAININGFILE));
		BufferedWriter testing = new BufferedWriter(new FileWriter(TESTINGFILE));
		
		//定义读取输入文件所需的一些数组
		int[] everyUserNum = new int[USER_ID];//用于存储每个用户打过分的item数量
		int[] user = new int[RATE_NUM];//对应数据库表格里的userID
		int[] item = new int[RATE_NUM];//对应数据库表格里的itemID
//		double[] rate = new double[RATE_NUM];//对应数据库表格里的rate
		int[] rate = new int[RATE_NUM];//对应数据库表格里的rate
		
		String lineRead = null;
		String lineWrite = null;
		String[] temp;
		
		//读取文件到数组中
		int i = 0;
		while ((lineRead = input.readLine()) != null) {
			temp = lineRead.split("\\s++");
			user[i] = Integer.valueOf(temp[0]);
			item[i] = Integer.valueOf(temp[1]);
//			rate[i] = Double.valueOf(temp[2]);
			rate[i] = Integer.valueOf(temp[2]);
//			System.out.println(user[i]+" "+item[i]+" "+rate[i]);
			i++;
		}
		input.close();
		
		//统计同一个用户的打分记录
		int j = 0;
		int everyCount = 1;
		for (int k = 0; k < user.length-1; k++) {
			if (user[k] == user[k+1]) {
				everyCount++;
			}else {
				everyUserNum[j] = everyCount;
				everyCount = 1;
//				System.out.println("userID:"+user[k]+"  "+"count:"+everyUserNum[j]);
				j++;
			}
			if (k == user.length-2) {
				everyUserNum[j] = everyCount;
//				System.out.println("userID:"+user[k]+"  "+"count:"+everyUserNum[j]);
			}
		}
		
		
		//按用户分组划分训练集和测试集
		int divideNum = 0;//数据划分为测试集的个数
		int rateIndex = 0;//记录打分记录数据的下标
		int kUser = 0;//记录前k个分组的总记录数
		HashSet<Integer> set = null;//用于存储每个用户分组里随机生成的不重复下标
		
		for (int k = 0; k < everyUserNum.length; k++) {
			int rateNum = everyUserNum[k];
			divideNum = (int)(rateNum*0.3);
			set = new HashSet<Integer>();
			randomSet(0,rateNum,divideNum,set);//随机生成相应数量的测试集下标
			
//			System.out.print(rateNum+"--");
//			System.out.print(divideNum+": ");
//			for (int j1 : set) {  
//		        System.out.print("\t"+j1);  
//		    }
//			
//			System.out.println("---------------");
			
			for (int l = 0; l < rateNum; l++) {
				
				rateIndex = kUser + l;
				lineWrite = user[rateIndex] + " " + item[rateIndex] + " " + rate[rateIndex];
				
				if (set.contains(l)) {
					testing.write(lineWrite);
					testing.newLine();
					testing.flush();
				}else {
					training.write(lineWrite);
					training.newLine();
					training.flush();
				}
			}
			
			kUser = kUser + rateNum;
		}
		
		training.close();
		testing.close();
	}
	
	/** 
	* 随机指定范围内N个不重复的数 ( min<=number<max)
	* 利用HashSet的特征，只能存放不同的值 
	* @param min 指定范围最小值 
	* @param max 指定范围最大值 
	* @param n 随机数个数 
	* @param HashSet<Integer> set 随机数结果集 
	*/  
	public static void randomSet(int min, int max, int n, HashSet<Integer> set) {  
		if (n > (max - min + 1) || max < min) {  
			return;  
		}
		
		int setSizeStart = set.size();//记录每次递归前的个数
		for (int i = 0; i < n; i++) {  
			// 调用Math.random()方法  
			int num = (int) (Math.random() * (max - min)) + min;  
			set.add(num);// 将不同的数存入HashSet中  
		}  
		int setSize = set.size();  
		// 如果存入的数小于指定生成的个数，则调用递归再生成剩余个数的随机数，如此循环，直到达到指定大小  
		if (setSize < n+setSizeStart) {  
			randomSet(min, max, n+setSizeStart - setSize, set);// 递归  
		}  
	}  
	
	public static void main(String[] args) throws FileNotFoundException, IOException {
		// TODO Auto-generated method stub
		creatTrainAndTest();
		System.out.println("-------------数据集划分已完成---------------");
	}

}
