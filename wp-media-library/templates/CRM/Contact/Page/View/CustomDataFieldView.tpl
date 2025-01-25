{*
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC. All rights reserved.                        |
 |                                                                    |
 | This work is published under the GNU AGPLv3 license with some      |
 | permitted exceptions and without any warranty. For full license    |
 | and copyright information, see https://civicrm.org/licensing       |
 +--------------------------------------------------------------------+
*}
<div id="custom-set-content-{$customGroupId}" {if $permission EQ 'edit' && !empty($cd_edit.editable)} class="crm-inline-edit" data-edit-params='{ldelim}"cid": "{$contactId}", "class_name": "CRM_Contact_Form_Inline_CustomData", "groupID": "{$customGroupId}", "customRecId": "{$customRecId}", "cgcount" : "{$cgcount}"{rdelim}' data-dependent-fields='["#crm-communication-pref-content"]'{/if}>
  <div class="crm-clear crm-inline-block-content" {if $permission EQ 'edit' && !empty($cd_edit.editable)}title="{ts}Edit{/ts}"{/if}>
    {if $permission EQ 'edit' && !empty($cd_edit.editable)}
      <div class="crm-edit-help">
        <span class="crm-i fa-pencil" aria-hidden="true"></span> {ts}Edit{/ts}
      </div>
    {/if}

    {foreach from=$cd_edit.fields item=element key=field_id}
      <div class="crm-summary-row">
        {if $element.options_per_line != 0}
          <div class="crm-label">{$element.field_title}</div>
          <div class="crm-content crm-custom_data">
              {* sort by fails for option per line. Added a variable to iterate through the element array*}
              {foreach from=$element.field_value item=val}
                {$val}
              {/foreach}
          </div>
        {else}
          <div class="crm-label">{$element.field_title}</div>
          {if $element.field_data_type EQ 'ContactReference' && $element.contact_ref_links}
            {*Contact ref id passed if user has sufficient permissions - so make a link.*}
            <div class="crm-content crm-custom-data crm-contact-reference">
              {', '|implode:$element.contact_ref_links}
            </div>
            {* RT START *}
          {elseif $element.field_type EQ 'Text'}
              {crmAPI var='result' entity='CustomField' action='get' return="name" id=$field_id}
              {assign var="field_name" value=$result.values[0].name}
              {if $field_name|strpos:"_lwp" !== false && $element.field_value != ""}
                <div class="crm-content crm-custom-data"><img src="{$element.field_value}" width="150px" height="150px"></div>
              {else}
                <div class="crm-content crm-custom-data">{$element.field_value}</div>
              {/if}
              {* RT END *}
          {else}
            <div class="crm-content crm-custom-data">{$element.field_value}</div>
          {/if}
        {/if}
      </div>
    {/foreach}
  </div>
</div>
