{*
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC. All rights reserved.                        |
 |                                                                    |
 | This work is published under the GNU AGPLv3 license with some      |
 | permitted exceptions and without any warranty. For full license    |
 | and copyright information, see https://civicrm.org/licensing       |
 +--------------------------------------------------------------------+
*}

{if $element.help_pre}
  <tr class="custom_field-help-pre-row {$element.element_name}-row-help-pre">
    <td>&nbsp;</td>
    <td class="html-adjust description">{$element.help_pre}</td>
  </tr>
{/if}
{if $element.html_type === 'Hidden'}
  {* Hidden field - render in hidden row *}
  <tr class="custom_field-row {$element.element_name}-row hiddenElement">
    <td>{$formElement.html}</td>
  </tr>
{elseif $element.options_per_line}
  <tr class="custom_field-row {$element.element_name}-row">
    <td class="label">{$formElement.label}{if $element.help_post}{help id=$element.id file="CRM/Custom/Form/CustomField.hlp" title=$element.label}{/if}</td>
    <td class="html-adjust">

      <div class="crm-multiple-checkbox-radio-options crm-options-per-line" style="--crm-opts-per-line:{$element.options_per_line};">
        {foreach name=outer key=key item=item from=$formElement}
          {if is_array($item) && array_key_exists('html', $item)}
            <div class="crm-option-label-pair" >{$formElement.$key.html}</div>
          {/if}
        {/foreach}
      </div>

      {* Include the edit options list for admins *}
      {if $formElement.html|strstr:"crm-option-edit-link"}
        {$formElement.html|regex_replace:"@^.*(<a href=.*? class=.crm-option-edit-link.*?</a>)$@":"$1"}
      {/if}

    </td>
  </tr>
{else}
  <tr class="custom_field-row {$element.element_name}-row">
    <td class="label">{$formElement.label}
      {if $element.help_post}{help id=$element.id file="CRM/Custom/Form/CustomField.hlp" title=$element.label}{/if}
    </td>
    <td class="html-adjust">
     {* RT START *}
      {if $element.name|strpos:"_lwp" !== false and $element.html_type eq 'Text' }
        <div id="" name="" class="" style="display:none;">
          {$formElement.html}
        </div>
        <div id="name-{$element.element_name}" name="name-{$element.element_name}" class="" ></div>
        {if $formElement.value != ''}
          <div id="img-{$element.element_name}" name="img-{$element.element_name}" class="img-{$element.element_name}" >
          <img id='' name='' class='' src='{$formElement.value}'></br>
          </div>
          <span class="button-delete-{$element.element_name}"><a class="action-item crm-hover-button small-popup" onclick="if (confirm(&quot;\u00cates-vous s\u00fbr de vouloir supprimer l'image.&quot;)) callWpMediaSuppress('#{$element.element_name}'); else return false;">Supprimer l'image</a></span>
        {else}
        <div id="crm-event-links-link" class="button button-{$element.element_name}" >Ajouter Media</div></a>
        {/if}
        {literal}
        <script type="text/javascript">
        jQuery(document).ready( function( $ ) {
          $('#{/literal}{$element.element_name}{literal}').addClass("hidden");
          {/literal}
          {if $formElement.value != ''}
           {literal}
              $('.img-{/literal}{$element.element_name}{literal}').css("max-height","150px");
            {/literal}
          {/if}
          {literal}
          $('.button-{/literal}{$element.element_name}{literal}').click(function(e) {
            callWpMediaUploadEvent('#{/literal}{$element.element_name}{literal}',"");
            console.log("Line 78: {/literal}{$element.element_name}{literal}");
          });

        $('#{/literal}{$element.element_name}{literal}').change(function(e) {
        console.log("changed {/literal}{$element.element_name}{literal}");
          if($("#{/literal}{$element.element_name}{literal}").val() == ""){
            $("#img-{/literal}{$element.element_name}{literal}").html("Cliquez sur 'Enregistrer' pour supprimer l'image d&eacute;finitivement.");
            $(".button-delete-{/literal}{$element.element_name}{literal}").addClass("hidden");
          }else{
            const url = new URL($("#{/literal}{$element.element_name}{literal}").val());
            console.log($("#{/literal}{$element.element_name}{literal}").val());
                var name = url.searchParams.get('filename');
                /*$("#crm-contact-image-name").html(name);*/
                console.log(name);
                $("#name-{/literal}{$element.element_name}{literal}").html(name);
                
          }
          });
        });

/***************************** Important! *************************************/
/* It is neccessary to include this function here, becuase the enqueued script 
in the plugin php doesn't work. I suspect that it is becuase this tpl is itself 
called via an ajax call (CRM.Buildform?) and it's scripts in this level don't seem to be able 
to communicate with other levels */
/*****************************************************************************/
function callWpMediaUploadEvent(element,imageSize){
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
  myplugin_media_upload.on( 'select', function(){
    var attachments = myplugin_media_upload.state().get('selection').map(
    function(attachment){
    
      // attachment.toJSON();
      var attachment = myplugin_media_upload.state().get('selection').first().toJSON();
      var outputURL;

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
      jQuery(element).val(outputURL);
      jQuery(element).trigger("change");
    });
  });
  myplugin_media_upload.open();
}


function callWpMediaSuppressEvent(element){

  jQuery(element).val("");
  jQuery(element).trigger("change");

}
        </script>
        {/literal}
      {else}
      {* RT END *}    
      {$formElement.html}&nbsp;
      {if $element.data_type eq 'File'}
        {if array_key_exists('element_value', $element) && $element.element_value.data}
          <div class="crm-attachment-wrapper crm-entity" id="file_{$element.element_name}">
            <span class="html-adjust"><br/>&nbsp;{ts}Attached File{/ts}: &nbsp;
              {if $element.element_value.displayURL}
                <a href="{$element.element_value.displayURL}" class='crm-image-popup crm-attachment'>
                  <img src="{$element.element_value.displayURL}"
                       height="{$element.element_value.imageThumbHeight}"
                       width="{$element.element_value.imageThumbWidth}">
                </a>
              {else}
                <a class="crm-attachment" href="{$element.element_value.fileURL}">{$element.element_value.fileName}</a>
              {/if}
              {if $element.element_value.deleteURL}
                <a href="#" class="crm-hover-button delete-attachment"
                   data-filename="{$element.element_value.fileName}"
                   data-args="{$element.element_value.deleteURLArgs}" title="{ts}Delete File{/ts}">
                  <span class="icon delete-icon"></span>
                </a>
              {/if}
            </span>
          </div>
        {/if}
      {elseif $element.html_type eq 'Autocomplete-Select'}
        {if $element.data_type eq 'ContactReference'}
          {assign var="element_name" value=$element.element_name}
          {include file="CRM/Custom/Form/ContactReference.tpl"}
        {/if}
      {/if}
      {/if}{* RT *}
    </td>
  </tr>
{/if}
