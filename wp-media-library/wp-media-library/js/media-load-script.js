jQuery(document).ready(function($) {
});

function callWpMediaUpload(element,imageSize){
	console.log("line 6 : "+element);

  var myplugin_media_upload;
  if( myplugin_media_upload ) {
      myplugin_media_upload.open();
      return;
  }
  // Extend the wp.media object
  myplugin_media_upload = wp.media.frames.file_frame = wp.media({
    //button_text set by wp_localize_script()
    title: "Bibliotheque de Media",
    button: { text: "Ajouter" },
    multiple: false //allowing for multiple image selection
    });
  console.log("line 19");	
	myplugin_media_upload.on( 'select', function(){
		/*console.log("line 22");	*/
    var attachments = myplugin_media_upload.state().get('selection').map(
    function(attachment){
    
      // attachment.toJSON();
      var attachment = myplugin_media_upload.state().get('selection').first().toJSON();
      var outputURL;
      var copyrightField = document.getElementById('acf-field_6085b32429eff');            
        
      if(copyrightField.value == ""){
        alert("Veuillez introduire le copyright!");
        myplugin_media_upload.open();
      }
      if(imageSize != "" && imageSize.toLowerCase() == "full"){
        if(attachment.sizes.full){
          outputURL = attachment.sizes.full.url+"?id="+attachment.id+"&name="+attachment.name+"&filename="+attachment.filename;
        }else{
          outputURL = attachment.url+"?id="+attachment.id+"&name="+attachment.name+"&filename="+attachment.filename;
        }
      }else if(imageSize != "" && imageSize.toLowerCase() == "medium" ){
        if(attachment.sizes.medium){
          outputURL = attachment.sizes.medium.url+"?id="+attachment.id+"&name="+attachment.name+"&filename="+attachment.filename;
        }else{
          outputURL = attachment.url+"?id="+attachment.id+"&name="+attachment.name+"&filename="+attachment.filename;
        }
      }else{
        outputURL = attachment.sizes.thumbnail.url+"?id="+attachment.id+"&name="+attachment.name+"&filename="+attachment.filename;
      }
      console.log("Line 44:" +element);
      console.log("Line 45:" +outputURL);
      jQuery(element).val(outputURL);
      console.log("Line 47:" +jQuery(element).val());
      jQuery(element).trigger("change");
    });
  });
  myplugin_media_upload.open();
}

function dump(obj) {
 var out = '';
 for (var i in obj) {
 out += i + ": " + obj[i] + "\n";
 }
console.log(out);
}

function callWpMediaSuppress(element){

  jQuery(element).val("");
  jQuery(element).trigger("change");

}



