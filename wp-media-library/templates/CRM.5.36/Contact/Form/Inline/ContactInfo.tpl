{*
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC. All rights reserved.                        |
 |                                                                    |
 | This work is published under the GNU AGPLv3 license with some      |
 | permitted exceptions and without any warranty. For full license    |
 | and copyright information, see https://civicrm.org/licensing       |
 +--------------------------------------------------------------------+
*}
{$form.oplock_ts.html}
<div class="crm-inline-edit-form">
  <div class="crm-inline-button">
    {include file="CRM/common/formButtons.tpl"}
  </div>

  <div class="crm-clear">
    {if $contactType eq 'Individual'}
    <div class="crm-summary-row">
      <div class="crm-label">{$form.employer_id.label}&nbsp;{help id="id-current-employer" file="CRM/Contact/Form/Contact.hlp"}</div>
      <div class="crm-content">
        {$form.employer_id.html|crmAddClass:big}
      </div>
    </div>
    <div class="crm-summary-row">
      <div class="crm-label">{$form.job_title.label}</div>
      <div class="crm-content">{$form.job_title.html}</div>
    </div>
    {/if}
    <div class="crm-summary-row">
      <div class="crm-label">{$form.nick_name.label}</div>
      <div class="crm-content">{$form.nick_name.html}</div>
    </div>
    {if $contactType eq 'Organization'}
    <div class="crm-summary-row">
      <div class="crm-label">{$form.legal_name.label}</div>
      <div class="crm-content">{$form.legal_name.html}</div>
    </div>
      {* RT SIC CODE Removed *}
      {* <div class="crm-summary-row">
        <div class="crm-label">{ts}SIC Code{/ts}</div>
        <div class="crm-content crm-contact-sic_code">{$sic_code}</div>
      </div>*}
    {/if}
    <div class="crm-summary-row">
      <div class="crm-label">{$form.contact_source.label}</div>
      <div class="crm-content">{$form.contact_source.html}</div>
    </div>
  </div> <!-- end of main -->
</div>
