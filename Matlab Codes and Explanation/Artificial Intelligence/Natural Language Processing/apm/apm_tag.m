
function response = apm_tag(server,app,name)
   app = lower(deblank(app));

    % Web-server URL base
    url_base = [deblank(server) '/online/get_tag.php'];

    % Send request to web-server
    params = ['?p=' urlencode(app) '&n=' urlencode(name)];
    url = [url_base params];
    % Send request to web-server
    response = str2num(urlread_apm(url));
