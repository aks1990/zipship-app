class HomeController < ShopifyApp::AuthenticatedController
  require 'json'
  require 'csv'

  def index
    @session_data_all = ShopifyAPI::Shop.current
    curr_store_id = @session_data_all.id
    
    @compare_shop_id = Home.find_by_shopid(curr_store_id)
    @zip_zone_list = Zip.select(:zone).map(&:zone).uniq
    @zip_new_comm_sep = Zip.new
    if @compare_shop_id.nil?
    
      zipcontent = Zipcontent.find_by_zipcount(1)

      Home.create(:heading => zipcontent.heading,
                :shopid => curr_store_id,
                :avail_msg => zipcontent.avail_msg,
                :notavail_msg => zipcontent.notavail_msg,
                :success_txt_color => zipcontent.success_txt_color,
                :fail_txt_color => zipcontent.fail_txt_color,
                :btn_color => zipcontent.btn_color,
                :btn_font_color => zipcontent.btn_font_color
        )


      names = Array.new
      @zip_list = Zip.all

      @zip_list.each do |zip_list|
        names << {"id": zip_list.id, "pincode": zip_list.pincode}
      end
      @zip_list_json = names.to_json


      ship_json_data = "var available_zip = "+@zip_list_json

      # create a snippet=======================================================
      @asset_snippet = ShopifyAPI::Asset.new(:key => 'snippets/ZipCode.liquid')
      @asset_snippet.value = '<div class="ship_calculator">'+
                              '<span><h2>'+zipcontent.heading+'</h2></span>'+
                              '<div class="ship_postal_srch">'+
                              '<input type="hidden" class="ship_total_weight"'+ 
                              'value="{{ cart.total_weight }}">'+
                              '<label>Postal Code:<span class="cart_imp">*</span></label>'+
                              '<input type="text" class="ship_postal_code">'+
                              '<span class="postal_error"></span>'+
                              '<a href="javascript:void(0);"'+ 
                              'class="btn shipping_status action_button">SUBMIT</a>'+
                              '<div class="add-product-loader">'+
                              '<img src="{{ "loader.gif" | asset_url }}"></div>'+
                              '</div></div>'+
                              '<div id="ship_target"></div><br class="clear" />'+
                              '<!-- =====================JS=========================='+
                              '================================================= -->'+
                              '<script>'+ship_json_data+'; $(".shipping_status").click(function(){'+
                             'var flag = 0;'+
                             '$(".add-product-loader").css("display","block");'+
                             'var cart_postal_code = $(".ship_postal_code").val();'+ 
                              'if(cart_postal_code !="")'+
                              '{'+
                                 '$.each(available_zip, function (key, code) {'+
                                   'if(cart_postal_code == code.pincode){'+
                                    'flag = 1;'+
                                   '}'+ 
                                 '});'+
                                'if(flag == 1){'+
                                  '$("#ship_target").empty();'+
                                  '$(".postal_error").empty();'+
                                  '$("#ship_target").html("'+zipcontent.avail_msg+'");'+
                                  '$(".add-product-loader").css("display","none");'+
                                '}'+
                                'else{'+
                                  '$("#ship_target").empty();'+
                                  '$(".postal_error").empty();'+
                                  '$("#ship_target").html("'+zipcontent.notavail_msg+'");'+
                                  '$(".add-product-loader").css("display","none");'+
                                '}'+
                              '}'+
                              'else{'+
                                '$("#ship_target").empty();'+
                                '$(".add-product-loader").css("display","none");'+
                                '$(".postal_error").text("*Postal code can not be blank.");'+
                              '}'+
                          '});</script>'+
                           '<!-- =====================CSS=========================='+
                           '================================================= -->'+
                           '<style>.add-product-loader {display: none;float: right;}'+
                          '.ship_calculator{width:100%;}'+
                          '.ship_postal_srch{width:20%; }'+
                          '.cart_imp{color:'+zipcontent.fail_txt_color+'; }'+
                          '.ship_calculator input{padding:0 !important; margin:0 !important; }'+
                          '#ship_target {margin-top: 20px; color:'+zipcontent.success_txt_color+';}'+
                          '.postal_error{color:red;font-weight: bold;}'+
                          '.btn.shipping_status.action_button {margin-top: 10px;width: 100%;background-color:'+zipcontent.btn_color+' !important;color:'+zipcontent.btn_font_color+'!important; }</style>'

      @asset_snippet.save
      # End here=========================================================

      # Add Snippet======================================================
      # @asset_edit = ShopifyAPI::Asset.find('templates/product.liquid')
      # @asset_edit.value += "<br><p>{% include 'ZipCode' %}</p>"
      # @asset_edit.save
      # End here=========================================================

      # Add Loader Image=================================================
      @asset_image = ShopifyAPI::Asset.new(:key => 'assets/loader.gif')
      @asset_image.src = 'https://cdn.shopify.com/s/files/1/1269/3465/files/loader.gif?5143915732747615527'
      @asset_image.save
      # End here=========================================================
    else 

      zipcontent = Home.find_by_shopid(curr_store_id)

      names = Array.new
      @zip_list = Zip.all

      @zip_list.each do |zip_list|
        names << {"id": zip_list.id, "pincode": zip_list.pincode}
      end
      @zip_list_json = names.to_json


      ship_json_data = "var available_zip = "+@zip_list_json

      # create a snippet=======================================================
      @asset_snippet = ShopifyAPI::Asset.new(:key => 'snippets/ZipCode.liquid')
      @asset_snippet.value = '<div class="ship_calculator">'+
                              '<span><h2>'+zipcontent.heading+'</h2></span>'+
                              '<div class="ship_postal_srch">'+
                              '<input type="hidden" class="ship_total_weight"'+ 
                              'value="{{ cart.total_weight }}">'+
                              '<label>Postal Code:<span class="cart_imp">*</span></label>'+
                              '<input type="text" class="ship_postal_code">'+
                              '<span class="postal_error"></span>'+
                              '<a href="javascript:void(0);"'+ 
                              'class="btn shipping_status action_button">SUBMIT</a>'+
                              '<div class="add-product-loader">'+
                              '<img src="{{ "loader.gif" | asset_url }}"></div>'+
                              '</div></div>'+
                              '<div id="ship_target"></div><br class="clear" />'+
                              '<!-- =====================JS=========================='+
                              '================================================= -->'+
                              '<script>'+ship_json_data+'; $(".shipping_status").click(function(){'+
                             'var flag = 0;'+
                             '$(".add-product-loader").css("display","block");'+
                             'var cart_postal_code = $(".ship_postal_code").val();'+ 
                              'if(cart_postal_code !="")'+
                              '{'+
                                 '$.each(available_zip, function (key, code) {'+
                                   'if(cart_postal_code == code.pincode){'+
                                    'flag = 1;'+
                                   '}'+ 
                                 '});'+
                                'if(flag == 1){'+
                                  '$("#ship_target").empty();'+
                                  '$(".postal_error").empty();'+
                                  '$("#ship_target").html("'+zipcontent.avail_msg+'");'+
                                  '$(".add-product-loader").css("display","none");'+
                                '}'+
                                'else{'+
                                  '$("#ship_target").empty();'+
                                  '$(".postal_error").empty();'+
                                  '$("#ship_target").html("'+zipcontent.notavail_msg+'");'+
                                  '$(".add-product-loader").css("display","none");'+
                                '}'+
                              '}'+
                              'else{'+
                                '$("#ship_target").empty();'+
                                '$(".add-product-loader").css("display","none");'+
                                '$(".postal_error").text("*Postal code can not be blank.");'+
                              '}'+
                          '});</script>'+
                           '<!-- =====================CSS=========================='+
                           '================================================= -->'+
                           '<style>.add-product-loader {display: none;float: right;}'+
                          '.ship_calculator{width:100%;}'+
                          '.ship_postal_srch{width:20%; }'+
                          '.cart_imp{color:'+zipcontent.fail_txt_color+'; }'+
                          '.ship_calculator input{padding:0 !important; margin:0 !important; }'+
                          '#ship_target {margin-top: 20px; color:'+zipcontent.success_txt_color+';}'+
                          '.postal_error{color:red;font-weight: bold;}'+
                          '.btn.shipping_status.action_button {margin-top: 10px;width: 100%;background-color:'+zipcontent.btn_color+' !important;color:'+zipcontent.btn_font_color+'!important; }</style>'

      @asset_snippet.save
      # End here=========================================================

      # Add Snippet======================================================
      # @asset_edit = ShopifyAPI::Asset.find('templates/product.liquid')
      # @asset_edit.value += "<br><p>{% include 'ZipCode' %}</p>"
      # @asset_edit.save
      # End here=========================================================

      # Add Loader Image=================================================
      @asset_image = ShopifyAPI::Asset.new(:key => 'assets/loader.gif')
      @asset_image.src = 'https://cdn.shopify.com/s/files/1/1269/3465/files/loader.gif?5143915732747615527'
      @asset_image.save
      # End here=========================================================

    end
  end

  def ziphome
    session_data_all = ShopifyAPI::Shop.current
    curr_store_id = session_data_all.id

    @edit_css = Home.find_by_shopid(curr_store_id)
  end

  def edit
    @home = Home.find_by_id(params[:id])
  end

  def update
    @home = Home.find(params[:home][:id])
    if @home.update_attributes(content_params)
      flash[:success] = "CSS updated"
      redirect_to action: "index"
    else
      render 'edit'
    end
  end

  def pincodeList
    @zip_new_comm_sep = Zip.new
    session_data_all = ShopifyAPI::Shop.current
    curr_store_id = session_data_all.id 
    @shopZipList = Zip.where(shopid: curr_store_id)
  end

  def import
      selected_filter_zone = params[:zone].downcase
      puts selected_filter_zone
      puts '========zone==============='
      
      params[:file].each do |file_name|
        file_ext = file_name.path.split('.').last
          @session_data_all = ShopifyAPI::Shop.current
          curr_store_id = @session_data_all.id
          zipcodes = Zip.all()
          zipList = Array.new
          zipCsvList = Array.new
          zipUniqueList = Array.new
          zipcodes.each do |zip|
              zipList << {"pincode": zip.pincode, "shopid": zip.shopid, "zone": zip.zone}
          end
          CSV.foreach(file_name.path) do |row|
            puts "==================row============="
            puts row.inspect
            pin_filter = row.inspect.split('"')
              zipCsvList << {"pincode": pin_filter[1], "shopid": curr_store_id, "zone": selected_filter_zone }
          end
          puts zipCsvList
          puts '========='
          puts zipList
          zipUniqueList = zipCsvList-zipList
        
          zipUniqueList.each do |zip_unq|
            Zip.create(:pincode => zip_unq[:pincode], :shopid => zip_unq[:shopid], :zone => zip_unq[:zone])
          end
          flash[:notice] = "Pincodes imported."
      end
      redirect_to action: "index"
  end

  def commaSeprtd
    session_data_all = ShopifyAPI::Shop.current
    curr_store_id = session_data_all.id
    zip_array = Array.new
    zip_list = Array.new
    zipUniqueList = Array.new
    zipcodes = Zip.all()
    zip_values = params[:zip][:pincode].split(',')
   
    zip_values.each do |pin|
      zip_array << {"pincode": pin, "shopid": curr_store_id, "zone": params[:zip][:zone]}
    end

    zipcodes.each do |zip|
      zip_list << {"pincode": zip.pincode, "shopid": zip.shopid, "zone": zip.zone}
    end

    zipUniqueList = zip_array-zip_list
    
      zipUniqueList.each do |zip_unq|
        Zip.create(:pincode => zip_unq[:pincode], :shopid => zip_unq[:shopid], :zone => zip_unq[:zone])
      end
      redirect_to root_url, notice: "Pincodes imported."
  end

  def exportCSV
    puts params
    session_data_all = ShopifyAPI::Shop.current
    curr_store_id = session_data_all.id
    @pincodes = Zip.select("pincode").where("shopid": curr_store_id, "zone": params[:zone])
    respond_to do |format|
      
      format.html
      format.csv { send_data @pincodes.to_csv, filename: "pincodes-#{Date.today}.csv" }
    end
  end

  private

    def content_params
      params.require(:home).permit(:success_txt_color, :fail_txt_color, :btn_font_color,
                                   :btn_color, :heading, :avail_msg, :notavail_msg)
    end
end
