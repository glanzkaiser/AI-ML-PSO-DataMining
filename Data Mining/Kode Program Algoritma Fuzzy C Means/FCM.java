import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

public class FCM {
	private float[][] data;
	private int jmlData, jmlVariabel;
	private int jmlCluster;
	private float pembobot;
	private int maksIterasi;
	private double epsilon;
	private int iterasi;
	private float[][] keanggotaan;
	private float [][] pusatCluster;
	
	public FCM(float[][] data, int jmlCluster, int maksIterasi, float pembobot, double epsilon) {
		this.data = data;
		this.jmlVariabel = data.length;
		this.jmlData = data[0].length;
		this.jmlCluster = jmlCluster;
		this.maksIterasi = maksIterasi;
		this.pembobot = pembobot;
		this.epsilon = epsilon;
		pusatCluster = new float[this.jmlData][this.jmlCluster];
		keanggotaan = new float[this.jmlData][this.jmlCluster];
		
		//tentukan nilai keanggotaan awal secara acak
		for (int i=0;i<this.jmlData;i++) {
			float jml = 0;
			for (int c=0;c<this.jmlCluster;c++) {
				keanggotaan[i][c] = 0 + (float)Math.random();
				jml += keanggotaan[i][c];
			}
			for (int c=0;c<this.jmlCluster;c++) keanggotaan[i][c] /= jml; 
		}

		//test
		for (int i=0;i<this.jmlData;i++) {
			float h = 0;
			for (int c=0;c<this.jmlCluster;c++) {
				h += keanggotaan[i][c];
				System.out.println("keanggotaan["+i+"]["+c+"] : "+ keanggotaan[i][c]);
			}
			System.out.println("h ["+i+"] : "+ h);
		}
	}	
		// Hitung pusat cluster dari fungsi keanggotaan 
	public void hitungPusatKlusterdariMF()
	{
		float atas, bawah;  
		// Untuk setiap variabel dan kluster
		for (int j=0;j<this.jmlVariabel;j++) {
			for(int c=0;c<jmlCluster;c++) {
				atas = bawah = 0;
				for (int i=0;i<this.jmlData;i++) {
					atas += Math.pow(keanggotaan[i][c],pembobot) * data[j][i];
					bawah += Math.pow(keanggotaan[i][c],pembobot);
				}
				pusatCluster[j][c] = atas / bawah; // hitung pusat cluster
				System.out.println("pusatCluster dari MF["+j+"]["+ c +"] : "+ pusatCluster[j][c]);
			}                                                               
		}
	}
	
		public void hitungMFdariPusatKluster()
	{
		float jum;
		float[][] aData = new float[jmlData][jmlVariabel];
		for(int c=0;c<jmlCluster;c++)
			for(int h=0;h<jmlData;h++)
			{
				for(int b=0;b<jmlVariabel;b++) aData[h][b] = data[b][h];
 				float top = hitungJarak(aData[h],pusatCluster[c]);
 				jum = 0f;
				for(int ck=0;ck<jmlCluster;ck++)
				{
					float jarak = hitungJarak(aData[h],pusatCluster[ck]);
					jum += Math.pow(top/jarak,(2f/(pembobot-1f)));
				}
				keanggotaan[h][c] = (float)(1f/jum);
				System.out.println("keanggotaan MF dari Pusat Kluster ["+h+"]["+c+"] : "+ keanggotaan[h][c]);
			}
	}

				
	// Euclidean 
	public float hitungJarak(float[] a1,float[] a2)
	{
		float jarak = 0f;
		for(int e=0;e<a1.length;e++) jarak += (a1[e]-a2[e])*(a1[e]-a2[e]);
		return (float)Math.sqrt(jarak);
	}

	
	// hitung fungsi obyektif
	public double hitungFungsiObyektif()
	{
		double j = 0;
		float[][] aData = new float[jmlData][jmlVariabel];
		for(int h=0;h<jmlData;h++) {
			for(int b=0;b<jmlVariabel;b++) {
				aData[h][b] = data[b][h];
			}
			for(int c=0;c<jmlCluster;c++) {
				float jarakCluster = hitungJarak(aData[h],pusatCluster[c]);
				j += jarakCluster*Math.pow(keanggotaan[h][c],pembobot);
			}
		}
		return j;	
	}
}
