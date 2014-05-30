function saveplotlyfig(data, layout, filename, format)

    [path, name, ext] = fileparts(filename);
    if nargin < 4
        format = 'png';
    end

    if isstruct(data)
        data = {{data}};
    elseif iscell(data)
        data = {data};
    end
    figure = struct('data', data, 'layout', layout, 'format', format);

    payload = m2json(figure);

    url = 'http://127.0.0.1:8080'; %'https://plot.ly/apigenimage/';

    [un, key] = signin;

    headers = struct(...
                    'name',...
                        {...
                            'plotly-username',...
                            'plotly-apikey',...
                            'plotly-version',...
                            'plotly-platform',...
                            'user-agent'
                        },...
                    'value',...
                        {...
                            un,...
                            key,...
                            '1.0',...
                            'MATLAB',...
                            'MATLAB'
                        });

    [response_string, extras] = urlread2(url, 'Post', payload, headers);
%    response_handler(response_string, extras);
%    response_object = loadjson(response_string);

    if strcmp(ext, '')
        filename = [filename '.' format];
    end

%    base64decode(response_object.payload, filename);
    if strcmp(format, 'svg')
        fileID = fopen(filename, 'w');
        fprintf(fileID, response_string);
        fclose(fileID);
    else
        base64decode(response_string, filename);
    end
end