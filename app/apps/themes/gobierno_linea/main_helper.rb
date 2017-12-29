module Themes::GobiernoLinea::MainHelper
  def self.included(klass)
    # klass.helper_method [:my_helper_method] rescue "" # here your methods accessible from views
  end

  def gobierno_linea_settings(theme)
    # callback to save custom values of fields added in my_theme/views/admin/settings.html.erb
  end

  # callback called after theme installed
  def gobierno_linea_on_install_theme(theme)
    default_post_type = [
      {name: 'Index', description: 'Historia y demas', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}},
      {name: 'Nuestro Municipio', description: 'Nuestro Municipio', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}},
      {name: 'Alcaldía', description: 'Alcaldía', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}},
      {name: 'Atencion al Ciudadano', description: 'Atencion al ciudadano', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}},
      {name: 'Tramites y Servicios', description: 'Tramites y Servicios', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}},
      {name: 'Participación Ciudadana', description: 'Participación Ciudadana', options: {has_category: false, has_tags: false, not_deleted: true, has_summary: false, has_content: true, has_comments: false, has_picture: true, has_template: true, has_layout: true}}
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

    # Home Slider
    gr = current_theme.add_field_group({name: "GEL Slider", slug: "gel_slider", is_repeat: true})
    gr.add_field({"name"=>"Title", "slug"=>"gel_slider_title"},{field_key: "text_box", translate: true})
    gr.add_field({"name"=>"Image", "slug"=>"gel_slider_image"},{field_key: "image"})
    gr.add_field({"name"=>"Description", "slug"=>"gel_slider_descr"},{field_key: "text_box", translate: true})

    # Terminos y servicios
    gr = current_theme.add_field_group({name: "GEL Servicios", slug: "gel_services", is_repeat: true})
    gr.add_field({"name"=>"Title", "slug"=>"gel_services_title"},{field_key: "text_box", translate: true})
    gr.add_field({"name"=>"Image", "slug"=>"gel_services_image"},{field_key: "image", required: true})
    gr.add_field({"name"=>"Description", "slug"=>"gel_services_descr"},{field_key: "text_box", translate: true})
    gr.add_field({"name"=>"Link", "slug"=>"gel_services_url"},{field_key: "url"})
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
end
