jQuery(function () {
  tinymce_global_settings["settings"].push(my_custom_function);
});
function my_custom_function(custom_settings, def_settings) {
  def_settings['templates'] = def_settings['templates'] || [];
  def_settings['templates'].push({ title: 'Simple', description: 'This is a simple template', content: a });
}

var a = `
  <div>
    <h1>Template titulo</h1>
    <h2>Otro mas</h2>    
    <div>Cuerpo </div>
  </div>
`