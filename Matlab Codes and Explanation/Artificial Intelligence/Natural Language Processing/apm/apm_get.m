
function [] = apm_get(server,app,filename)
   %ambil ip address utk web-address lookup
   app = lower(deblank(app));
   ip = deblank(urlread_apm([deblank(server) '/ip.php']));    
   url = [deblank(server) '/online/' ip '_' app '/' filename];
   response = urlread_apm(url);
   % tulis file
   fid = fopen(filename,'w');
   fwrite(fid,response);
   fclose(fid);
