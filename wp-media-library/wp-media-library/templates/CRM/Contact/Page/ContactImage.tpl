{*
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC. All rights reserved.                        |
 |                                                                    |
 | This work is published under the GNU AGPLv3 license with some      |
 | permitted exceptions and without any warranty. For full license    |
 | and copyright information, see https://civicrm.org/licensing       |
 +--------------------------------------------------------------------+
*}
{* RT This form is for displaying contact Image *}
{crmRegion name="contact-summary-image"}
  <div class="crm-contact_image crm-contact_image-block">
  {* RT START *}
  {if $imageURL|strstr:".svg"}
    {if empty($result.values.0.image_URL)}
     {crmAPI var='result' entity='Contact' action='get' return="image_URL" id=$contactId}
    {/if}
      <img src="{$result.values.0.image_URL}" style="width:125px;height:125px;"/>
  {else}
     {$imageURL}
  {/if}
  {* RT END *}
  </div>
  {if $action eq 0 or $action neq 1 and $deleteURL}
    <div class='crm-contact_image-block crm-contact_image crm-contact_image-delete'>{$deleteURL}</div>
  {/if}
{/crmRegion}
