
function response = apm(server,app,aline)

    % Web-server URL base
    url_base = [deblank(server) '/online/apm_line.php'];
    app = lower(deblank(app));
    params = ['?p=' urlencode(app) '&a=' urlencode(aline)];
    url = [url_base params];
    % kirim request ke web-server
    response = urlread_apm(url);
    
    % hapus newline characters dari response
    newline = sprintf('\r');
    response = strrep(response,newline,'');
