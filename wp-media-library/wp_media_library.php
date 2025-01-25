<?php

require_once 'wp_media_library.civix.php';

use CRM_WpMediaLibrary_ExtensionUtil as E;

/**
 * Implements hook_civicrm_config().
 *
 * @link https://docs.civicrm.org/dev/en/latest/hooks/hook_civicrm_config/
 */
function wp_media_library_civicrm_config(&$config): void {
  _wp_media_library_civix_civicrm_config($config);
}

/**
 * Implements hook_civicrm_install().
 *
 * @link https://docs.civicrm.org/dev/en/latest/hooks/hook_civicrm_install
 */
function wp_media_library_civicrm_install(): void {
  _wp_media_library_civix_civicrm_install();
}

/**
 * Implements hook_civicrm_enable().
 *
 * @link https://docs.civicrm.org/dev/en/latest/hooks/hook_civicrm_enable
 */
function wp_media_library_civicrm_enable(): void {
  _wp_media_library_civix_civicrm_enable();
}

function enqueue_styles(){

  if ( ! wp_script_is( 'custom-script', 'enqueued' ) ) {

    $extUrlJs = CRM_Core_Resources::singleton()->getUrl('wp-media-library', 'js/custom-script.js');

    wp_deregister_script( 'custom-script' );
    wp_register_script('custom-script', $extUrlJs, array('jquery'), null, true);
    wp_enqueue_script('custom-script');

  }

  if ( ! wp_style_is( 'civicrm-wp-media-css', 'enqueued' ) ) {

    $extUrlCss = CRM_Core_Resources::singleton()->getUrl('wp-media-library', 'css/civicrm-wp-media.css');

    wp_deregister_style( 'civicrm-wp-media-css' );
    wp_register_style( 'civicrm-wp-media-css', $extUrlCss, false, NULL, 'all'); 
    wp_enqueue_style( 'civicrm-wp-media-css' );
  
  }

}

if ( function_exists( 'add_action' ) ){

add_action( 'wp_enqueue_scripts', 'enqueue_styles' );

}
function load_wp_media_files() {

  wp_enqueue_media();
  
  
  if ( ! wp_script_is( 'media-load-script', 'enqueued' ) ) {

    $extUrlJs = CRM_Core_Resources::singleton()->getUrl('wp-media-library', 'js/media-load-script.js');

    wp_deregister_script( 'media-load-script' );
    wp_register_script('media-load-script', $extUrlJs, array('jquery'), null, false);
    wp_enqueue_script('media-load-script');

  }

}

/************** Hooks - CIVICRM *******************/

function wp_media_library_civicrm_postProcess($formName, &$form) {

  if( isset($GLOBALS['stackLog']) ){   error_log(__FUNCTION__." ".__LINE__." ".$formName) ; };

  if ($formName == 'CRM_Custom_Form_Field') {
    
    $values = $form->getVar('_values');

    if(!isset($values['name'])){

      $tmpValues = $form->getVar( 'ajaxResponse' );
      $values = $tmpValues['customField'];
      
    }

    $name = $values['name'];
    $ID = (int)$values['id'];
       // ajaxResponse customField
    $submitValues = $form->getVar( '_submitValues' );

    $posSuffix = strpos("_lwp",$name);
    if((!empty($submitValues['link_to_wp']) &&  $submitValues['link_to_wp'] == 1) && $posSuffix < 1) {
      $name = $values['name']."_lwp";
      
      if ($name != $values['name'] &&  isset($values['id'])){
        $query = "UPDATE civicrm_custom_field SET name = '%1' WHERE id = %2";
        $params = array(1  => array($name, 'Text'),2  => array( $ID, 'Integer'));
        //  $tmp =  CRM_Core_DAO::composeQuery($query, $params);
        // error_log(print_r($tmp, true));  
        CRM_Core_DAO::executeQuery($query, $params);
      }

    } 

  }

  if ($formName == 'CRM_Contact_Form_Contact') {
    $submitValues = $form->getVar( '_submitValues' );
    $values = $form->getVar('_values');
   
    if(!empty($submitValues['image_URL']) && !empty($values['id'])){

      $contactID = $values['id'];
      $query = "UPDATE civicrm_contact SET image_URL = '%1' WHERE id = %2";
      
      $params = array(1  => array($submitValues['image_URL'], 'Text'),2  => array( $contactID, 'Integer'));
      CRM_Core_DAO::executeQuery($query, $params);
      // $tmp =  CRM_Core_DAO::composeQuery($query, $params);

    }

  }


  if ( $formName == 'CRM_Profile_Form_Edit') {
    $submitValues = $form->getVar( '_submitValues' );
    $contact_id = CRM_Core_Session::singleton()->getLoggedInContactID();

   
    if(!empty($submitValues['image_URL']) &&  $contact_id != ""){
      $contactID = $contact_id;
      $query = "UPDATE civicrm_contact SET image_URL = '%1' WHERE id = %2";
      // error_log(print_r($query, true));
      $params = array(1  => array($submitValues['image_URL'], 'Text'),2  => array( $contactID, 'Integer'));
      CRM_Core_DAO::executeQuery($query, $params);
      // $tmp =  CRM_Core_DAO::composeQuery($query, $params);
    }

  }

}


function wp_media_library_civicrm_preProcess($formName, &$form) {

  if( isset($GLOBALS['stackLog']) ){   error_log(__FUNCTION__." ".__LINE__." ".$formName);  };

   if ($formName == 'CRM_Event_Form_ManageEvent_EventInfo') {

     // error_log(__FUNCTION__." ".$formName);
    // error_log(print_r($form->getVar( 'image_URL' ), true));
  }

}



function wp_media_library_civicrm_pre($op, $objectName, $id, &$params) {

  if( isset($GLOBALS['stackLog']) ){   error_log(__FUNCTION__." ".__LINE__." ".$objectName) ; };

  if("Organization" == $objectName){
   // error_log(__FUNCTION__." ".$objectName." ".$op);
  }

}


function wp_media_library_civicrm_buildForm($formName, &$form) {

  if( isset($GLOBALS['stackLog']) ){   error_log(__FUNCTION__." ".__LINE__." ".$formName);  };

  if ($formName == 'CRM_Custom_Form_Field') {

  }
        // '
  // CRM_Custom_Form_CustomDataByType

 
  if ($formName == 'CRM_Event_Form_ManageEvent_EventInfo' || $formName == 'CRM_Custom_Form_CustomDataByType'){
    /* Don't enqueue the load_wp_media_files here, CRM_Event_Form_ManageEvent_EventInfo is an exception and the funtion is copied directly into the tpl otherwise it won't work*/
  }

  if ($formName == 'CRM_Contact_Form_Contact'  || $formName == 'CRM_Activity_Form_ActivityLinks' || $formName == 'CRM_Event_Form_SearchEvent' || $formName == 'CRM_Event_Form_ManageEvent_EventInfo') {
    if( function_exists( 'add_action' )){

      add_action( 'admin_enqueue_scripts', 'load_wp_media_files' ,10);

    }
    
  }

  if($formName == 'CRM_Profile_Form_Edit'){

    if( function_exists( 'add_action' )){

      add_action( 'wp_enqueue_scripts', 'load_wp_media_files' );

    }
  }
}


function wp_media_library_civicrm_buildProfile($profileName) {

  if( isset($GLOBALS['stackLog']) ){   error_log(__FUNCTION__." ".__LINE__." ".$profileName);  };

  if ($profileName === 'supporter_profile_Copy_id_14__14') {

    // Civi::resources()->addScriptFile('org.example.myext', 'some/fancy.js', 100);
    
  }
}


