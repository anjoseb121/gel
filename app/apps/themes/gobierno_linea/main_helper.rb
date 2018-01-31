module Themes::GobiernoLinea::MainHelper
  def self.included(klass)
    klass.helper_method [:documents_types] rescue "" # here your methods accessible from views
  end

  def gobierno_linea_settings(theme)
    # callback to save custom values of fields added in my_theme/views/admin/settings.html.erb
  end

  def documents_types
    [
      ['Cédula de Ciudadanía', 'CC'],
      ['Cédula Extranjeria', 'CE'],
      ['Registro Civil', 'RC'],
      ['Tarjeta Identidad', 'TI'],
      ['Número de identificación Tributaria', 'NIT'],
      ['Tarjeta Decadactilar', 'TD'],
      ['Pasaporte', 'PA'],
      ['No Reportado', 'NR']
    ]
  end

  # callback called after theme installed
  def gobierno_linea_on_install_theme(theme)
    default_post_type = [
      {name: 'Index', description: 'Historia y demas', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}},
      {name: 'Nuestro Municipio', description: 'Nuestro Municipio', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}},
      {name: 'Alcaldía', description: 'Alcaldía', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}},
      {name: 'Atencion al Ciudadano', description: 'Atencion al ciudadano', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}},
      {name: 'Tramites y Servicios', description: 'Tramites y Servicios', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}},
      {name: 'Participación Ciudadana', description: 'Participación Ciudadana', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}},
      
      {name: 'Estratificación Socioeconómica', description: 'Certificado de estratificación socioeconómica', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}}
    ]
    default_post_type.each do |pt|
      model_pt = theme.site.post_types.create({name: pt[:name], slug: pt[:name].to_s.parameterize, description: pt[:description], data_options: pt[:options]})
    end

    # nav menus
    unless theme.site.nav_menus.where(slug: "gel_help_menu").any?
      theme.site.nav_menus.create(name: "GEL Help menu", slug: "gel_help_menu")    
    end

    unless theme.site.nav_menus.where(slug: "gel_main_menu").any?
      @nav_menu = theme.site.nav_menus.new({name: "GEL Main menu", slug: "gel_main_menu"})
      if @nav_menu.save
        theme.site.post_types.all.each do |pt|
          unless pt.slug == 'post' || pt.slug == 'page'
            # title = pt.name
            # slug = pt.slug
            # content = pt.description
            # post = pt.add_post({title: title, slug: slug, content: content, user_id: 1, status: 'published'})
            @nav_menu.append_menu_item({label: pt.slug, type: pt.taxonomy, link: pt.id})
          end
        end
      end
    end

    # Main Color
    theme.add_field({"name"=>"Color principal", "slug"=>"main_color"},{field_key: "colorpicker", color_format: "rgb", default_value: "rgb(4,57,80)"})

    # Secondary Color
    theme.add_field({"name"=>"Color segundario", "slug"=>"secondary_color"},{field_key: "colorpicker", color_format: "rgb", default_value: "rgb(243,165,54)"})

    # Main image
    theme.add_field({"name"=>"Imagen principal", "slug"=>"main_image"},{field_key: "image"})

    # Home Slider
    gr = current_theme.add_field_group({name: "GEL Slider", slug: "gel_slider", is_repeat: true})
    gr.add_field({"name"=>"Title", "slug"=>"gel_slider_title"},{field_key: "text_box", translate: true})
    gr.add_field({"name"=>"Image", "slug"=>"gel_slider_image"},{field_key: "image"})
    gr.add_field({"name"=>"Description", "slug"=>"gel_slider_descr"},{field_key: "text_box", translate: true})

    # Footer
    group = theme.add_field_group({name: "Footer", slug: "footer"})
    group.add_field({"name"=>"Superior", "slug"=>"footer_left"}, {field_key: "editor", translate: true, default_value: "<h4>My Bunker</h4><p>Some Address 987,<br> +34 9054 5455, <br> Madrid, Spain. </p>"})
    group.add_field({"name"=>"Centro", "slug"=>"footer_center"}, {field_key: "editor", translate: true, default_value: "<h4>My Links</h4> <p><a href='#'>Dribbble</a><br> <a href='#'>Twitter</a><br> <a href='#'>Facebook</a></p>"})
    group.add_field({"name"=>"Inferior", "slug"=>"footer_right"}, {field_key: "editor", translate: true, default_value: "<h4>About Theme</h4><p>This cute theme was created to showcase your work in a simple way. Use it wisely.</p>"})

    # Terminos y servicios
    gr = current_theme.add_field_group({name: "GEL Servicios", slug: "gel_services", is_repeat: true})
    gr.add_field({"name"=>"Title", "slug"=>"gel_services_title"},{field_key: "text_box", translate: true})
    gr.add_field({"name"=>"Image", "slug"=>"gel_services_image"},{field_key: "image"})
    gr.add_field({"name"=>"Description", "slug"=>"gel_services_descr"},{field_key: "text_box", translate: true})
    gr.add_field({"name"=>"Link", "slug"=>"gel_services_url"},{field_key: "url"})

    # Colaboradores
    gr = current_theme.add_field_group({name: "GEL Colaboradores", slug: "gel_collaborators", is_repeat: true})
    gr.add_field({"name"=>"Title", "slug"=>"gel_collaborators_title"},{field_key: "text_box", translate: true})
    gr.add_field({"name"=>"Image", "slug"=>"gel_collaborators_image"},{field_key: "image"})
    gr.add_field({"name"=>"Link", "slug"=>"gel_collaborators_url"},{field_key: "url"})
  end

  # callback executed after theme uninstalled
  def gobierno_linea_on_uninstall_theme(theme)
    theme.get_field_groups().destroy_all
    theme.destroy
  end

  def slider_custom_fields(args)
    args[:fields][:my_slider] = {
      key: 'my_slider',
      label: 'My Slider',
      render: theme_view('custom_field/my_slider.html.erb'),
      options: {
        required: true,
        multiple: true,
      },
      extra_fields:[
        {
          type: 'text_box',
          key: 'dimension',
          label: 'Dimensions',
          description: 'Crop images with dimension (widthxheight), sample:<br>400x300 | 400x | x300 | ?400x?500 | ?1400x (? => maximum, empty => auto)'
        }
      ]
    }
  end

  def procedure_custom_fields(args)
    args[:fields][:my_procedures] = {
      key: 'my_procedures',
      label: 'My Procedure',
      render: theme_view('custom_field/my_procedures.html.erb'),
      options: {
        required: true,
        multiple: true,
      },
      extra_fields:[
        {
          type: 'text_box',
          key: 'dimension',
          label: 'Dimensions',
          description: 'Crop images with dimension (widthxheight), sample:<br>400x300 | 400x | x300 | ?400x?500 | ?1400x (? => maximum, empty => auto)'
        }
      ]
    }
  end

  def my_theme_admin_before_load
    append_asset_libraries({"my_tinymce"=> { js: [theme_asset("js/my_tinymce_templates")]}})
  end
end
