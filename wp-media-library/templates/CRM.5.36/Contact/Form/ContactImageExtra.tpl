{*
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC. All rights reserved.                        |
 |                                                                    |
 | This work is published under the GNU AGPLv3 license with some      |
 | permitted exceptions and without any warranty. For full license    |
 | and copyright information, see https://civicrm.org/licensing       |
 +--------------------------------------------------------------------+
*}
          <table class="image_URL-section form-layout-compressed">
            <tr>
              <td>
              <label for="image_URL"><strong>Logo/Image Profile/Avatar (512px x 512px Maximum)</strong></label><br />
                {$form.image_URL.label}&nbsp;&nbsp;{help id="id-upload-image" file="CRM/Contact/Form/Contact.hlp"}<br />
                {* RT *}
                {*$form|crmAddClass:twenty*}
                 {crmAPI var='result' entity='Contact' action='get' return="image_URL" id=$contactId}
                <input name="image_URL" type="hidden" id="image_URL" class="{*twenty crm-form-file*}" value='{$result.values.0.image_URL}'>
                {* END RT *}
                {if !empty($imageURL)}
                  {include file="CRM/Contact/Page/ContactImage.tpl"}
                {else}
                  <div id="crm-contact-image" name="crm-contact-image" class="button button-media" >Ajouter Media</div><div id="crm-contact_image_loaded" class="" ></div>
                  <div id="crm-contact-image-name" name="crm-contact-image-name" class="" ></div>
                {literal}
                <script type="text/javascript">
                jQuery(document).ready( function( $ ) {
                  $('.button-media').click(function(e) {
                    callWpMediaUpload('#image_URL',"medium");
                    //console.log(' Line 30 : #image_URL');
                  });

                  $("#image_URL").change(function(e) {
                  	const url = new URL($("#image_URL").val());

                    var name = url.searchParams.get('filename');
                    $("#crm-contact-image-name").html(name);
                    //console.log("name:"+name);
                  });
                });
                </script>
                {/literal}
                {/if}

              </td>
            </tr>
          </table>
