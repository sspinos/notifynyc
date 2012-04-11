object @user
attributes :id, :name, :nickname, :created_at, :updated_at
(node(:csv){ "#{@domain_key}/#{params[:controller]}#{params[:action] == '/show' ? '/#{params[:id]}' : (params[:action] == 'index' ? '' : '/#{params[:action]}')}.csv" }) unless request.fullpath.include?('csv')