import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

public class CobaFCM {
	public static void main (String[] args) {
			float[][] data = {{14,8,18,5,8,9,5,10,3,10},
									{19,12,20,14,12,19,2,8,3,8}};
			int jmlCluster = 3;
			int maksIterasi = 100;
			float pembobot = 2F;
			double epsilon = 0.000001;
			double JAkhir, j; 
			BufferedReader dataIn = new BufferedReader(new InputStreamReader( System.in) );
			FCM fcm = new FCM(data, jmlCluster, maksIterasi, pembobot, epsilon);
			
			JAkhir = fcm.hitungFungsiObyektif(); 
			for(int iterasi=0;iterasi<maksIterasi;iterasi++) {
				System.out.println("-------- Iterasi -------- : " + iterasi ) ;
				fcm.hitungPusatKlusterdariMF(); 
				fcm.hitungMFdariPusatKluster(); 
				j = fcm.hitungFungsiObyektif(); 
				System.out.println("Nilai J\t\t: "+j);
				System.out.println("Nilai J Akhir\t\t: "+ JAkhir);
				System.out.println("Nilai Math.abs(JAkhir-j)\t: "+ Math.abs(JAkhir-j));
				if (Math.abs(JAkhir-j) < epsilon) break; 
				JAkhir = j;
				try {
					String g = dataIn.readLine();
				} catch (Exception e) {
				}
		}
	}
}
