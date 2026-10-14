{if isset($dedications) && $dedications}
<div class="cart-dedications-container mt-2">
    {foreach from=$dedications item=d}
        
        {if isset($d.dedication_type) && $d.dedication_type == 'blind_date'}
            
            <div class="dedication-item p-3 mb-2 rounded" style="background: #fdfbfd; border: 2px dashed #e5d1ff; position: relative;">
                <div style="margin-bottom: 8px;">
                    <span style="background: #9b59b6; color: #fff; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: bold;">✨ {l s='Blind Date Preferences' mod='productcustomizer'}</span>
                </div>
                
                <small class="text-muted">{l s='Product:' mod='productcustomizer'} {$d.product_name}</small><br>
                
                <div class="mt-2" style="font-size: 14px; color: #333; line-height: 1.6; font-weight: 500;">
                    {$d.message|escape:'html':'UTF-8'|nl2br nofilter}
                </div>

                <div class="dedication-actions mt-3">
                    <button type="button" 
                            class="btn btn-sm btn-light border edit-blind-date-btn mr-2"
                            data-id="{$d.id_dedication}"
                            data-id-product="{$d.id_product}"
                            data-message="{$d.message|escape:'html':'UTF-8'}"
                            data-toggle="modal" 
                            data-target="#editBlindDateModal"
                            style="color: #9b59b6; font-weight: bold;">
                        <i class="material-icons" style="font-size: 14px; vertical-align: middle;">edit</i> {l s='Edit preferences' mod='productcustomizer'}
                    </button>

                    <button type="button" 
                            class="btn btn-sm btn-outline-danger delete-dedication-btn"
                            data-id="{$d.id_dedication}"
                            data-url="{$link->getModuleLink('productcustomizer', 'save')}">
                        <i class="material-icons" style="font-size: 14px; vertical-align: middle;">delete</i> {l s='Remove' mod='productcustomizer'}
                    </button>
                </div>
            </div>

        {else}
            <div class="dedication-item p-3 mb-2 border rounded" 
                 data-id="{$d.id_dedication}"
                 style="background-image: url('{$d.background}'); background-size: cover; background-position: center; min-height: 100px; position: relative;">
                
                <div style="background: rgba(255, 255, 255, 0.9); padding: 12px; border-radius: 8px; display: inline-block; max-width: 100%;">
                    <div style="margin-bottom: 5px;">
                        {if isset($d.dedication_type) && $d.dedication_type == 'card'}
                            <span style="background: #f8f1ff; color: #9b59b6; padding: 3px 8px; border-radius: 12px; font-size: 12px; font-weight: bold; border: 1px solid #e5d1ff;">💌 {l s='Greeting card attached' mod='productcustomizer'} </span>
                        {elseif isset($d.dedication_type) && $d.dedication_type == 'book'}
                            <span style="background: #f0f8ff; color: #3498db; padding: 3px 8px; border-radius: 12px; font-size: 12px; font-weight: bold; border: 1px solid #bce8f1;">📖 {l s='Dedication on the first page of the book' mod='productcustomizer'}</span>
                        {/if}
                    </div>

                    <small class="text-muted">{l s='Book:' mod='productcustomizer'} {$d.product_name}</small><br>
                    <div class="dedication-text mt-1" style="font-family: {$d.font}; color: {$d.color}; font-size: 16px; font-weight: bold;">
                        {$d.message|escape:'html':'UTF-8'|nl2br nofilter}
                    </div>
                </div>

                <div class="dedication-actions mt-2">
                    <button type="button" class="btn btn-sm btn-light border edit-dedication-btn" data-id="{$d.id_dedication}" data-id-product="{$d.id_product}" data-id-attribute="{$d.id_product_attribute}" data-message="{$d.message|escape:'html':'UTF-8'}" data-font="{$d.font}" data-color="{$d.color}" data-background="{$d.background}" data-type="{if isset($d.dedication_type)}{$d.dedication_type}{else}card{/if}" data-toggle="modal" data-target="#editDedicationModal">
                        <i class="material-icons">edit</i> Edit
                    </button>
                    <button type="button" class="btn btn-sm btn-danger delete-dedication-btn" data-id="{$d.id_dedication}" data-url="{$link->getModuleLink('productcustomizer', 'save')}">
                        <i class="material-icons">delete</i>
                    </button>
                </div>
            </div>
        {/if}
    {/foreach}
</div>

<div class="modal fade" id="editDedicationModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">{l s='Edit Dedication' mod='productcustomizer'}</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="modal_edit_id">
        <input type="hidden" id="modal_product_id">
        <input type="hidden" id="modal_product_attribute">
        
        <div class="custom-dedication-extra-options mb-3" style="padding: 10px; background: #fdfbfd; border: 1px solid #f0e6f7; border-radius: 8px;">
            <label style="font-weight: bold; display: block; margin-bottom: 8px;">{l s='Type' mod='productcustomizer'}</label>
            <div class="dedication-type-selector">
                <label class="dedication-radio">
                    <input type="radio" name="modal_dedication_type" value="card">
                    <span class="radio-label">💌 {l s='Greeting card attached' mod='productcustomizer'}</span>
                </label>
                <label class="dedication-radio">
                    <input type="radio" name="modal_dedication_type" value="book">
                    <span class="radio-label">📖 {l s='Dedication on the first page of the book' mod='productcustomizer'}</span>
                </label>
            </div>
        </div>

        <div class="form-group">
            <label style="font-weight: bold;">{l s='Message' mod='productcustomizer'}</label>
            <textarea id="modal_edit_message" class="form-control" rows="3"></textarea>
        </div>
        
        <div class="row">
            <div class="col-6 form-group">
                <label style="font-weight: bold;">{l s='Font' mod='productcustomizer'}</label>
                <select id="modal_edit_font" class="form-control">
                    <option value="Arial">Arial</option>
                    <option value="Georgia">Georgia</option>
                    <option value="cursive">Cursive</option>
                    <option value="Times New Roman">Times New Roman</option>
                </select>
            </div>
            <div class="col-6 form-group">
                <label style="font-weight: bold;">{l s='Color' mod='productcustomizer'}</label>
                <input type="color" id="modal_edit_color" class="form-control" style="height: 40px;">
            </div>
        </div>

        <div class="form-group mt-2">
            <label style="font-weight: bold;">{l s='Background' mod='productcustomizer'}</label>
            <div class="d-flex align-items-center flex-wrap" style="gap: 10px; margin-top: 5px;">
                <img src="{$module_dir}views/img/bg_flower.png" class="modalBgOption" data-bg="{$module_dir}views/img/bg_flower.png" style="width:40px; height:40px; cursor:pointer; border:1px solid #ccc; border-radius:5px; object-fit:cover;">
                <img src="{$module_dir}views/img/bg_heart.png" class="modalBgOption" data-bg="{$module_dir}views/img/bg_heart.png" style="width:40px; height:40px; cursor:pointer; border:1px solid #ccc; border-radius:5px; object-fit:cover;">
                <label for="modal_custom_bg_image" class="btn btn-outline-primary btn-sm mb-0" style="cursor: pointer; border-color: #9b59b6; color: #9b59b6; padding: 6px 10px;">
                    <i class="material-icons" style="font-size: 16px; vertical-align: middle;">cloud_upload</i> PC
                </label>
                <input type="file" id="modal_custom_bg_image" name="modal_custom_bg_image" accept="image/png, image/jpeg" style="display: none;">
            </div>
            <span id="modal-file-name" class="d-block mt-1 text-muted" style="font-size: 12px; font-style: italic;"></span>
            <input type="hidden" id="modal_edit_background">
        </div>
        <div id="modal-response" class="alert mt-2" style="display:none;"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">{l s='Close' mod='productcustomizer'}</button>
        <button type="button" class="btn btn-primary" id="btn-modal-save" data-url="{$link->getModuleLink('productcustomizer', 'save')}" style="background-color: #9b59b6; border-color: #9b59b6;">{l s='Save changes' mod='productcustomizer'}</button>
      </div>
    </div>
  </div>
</div>
{/if}
<div class="modal fade" id="editBlindDateModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="border: 2px dashed #e5d1ff; border-radius: 12px;">
      <div class="modal-header" style="background: #fdfbfd; border-bottom: none;">
        <h5 class="modal-title" style="color: #9b59b6; font-weight: bold;">✨ Edit Blind Date Preferences</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="modal_bd_id">
        <input type="hidden" id="modal_bd_product">

        <div class="form-group mb-3">
            <label style="font-weight: bold;">1. Genre:</label>
            <div class="dedication-type-selector">
                <label class="dedication-radio"><input type="radio" name="modal_bd_genre" value="Romance"><span class="radio-label">💖 Romance</span></label>
                <label class="dedication-radio"><input type="radio" name="modal_bd_genre" value="Fantasy"><span class="radio-label">🐉 Fantasy</span></label>
                <label class="dedication-radio"><input type="radio" name="modal_bd_genre" value="Thriller / Mystery"><span class="radio-label">🕵️‍♀️ Thriller / Mystery</span></label>
                <label class="dedication-radio"><input type="radio" name="modal_bd_genre" value="Historical Fiction"><span class="radio-label">🕰️ Historical</span></label>
            </div>
        </div>

        <div class="form-group mb-3">
            <label style="font-weight: bold;">2. Tropes (Max 3):</label>
            <div class="dedication-type-selector">
                <label class="dedication-checkbox"><input type="checkbox" name="modal_bd_tropes" value="Enemies to Lovers"><span class="radio-label">Enemies to Lovers</span></label>
                <label class="dedication-checkbox"><input type="checkbox" name="modal_bd_tropes" value="Dark Academia"><span class="radio-label">Dark Academia</span></label>
                <label class="dedication-checkbox"><input type="checkbox" name="modal_bd_tropes" value="Slow Burn"><span class="radio-label">Slow Burn</span></label>
                <label class="dedication-checkbox"><input type="checkbox" name="modal_bd_tropes" value="Plot Twist"><span class="radio-label">Plot Twist</span></label>
                <label class="dedication-checkbox"><input type="checkbox" name="modal_bd_tropes" value="Grumpy x Sunshine"><span class="radio-label">Grumpy x Sunshine</span></label>
                <label class="dedication-checkbox"><input type="checkbox" name="modal_bd_tropes" value="Found Family"><span class="radio-label">Found Family</span></label>
            </div>
        </div>

        <div class="form-group mb-2">
            <label style="font-weight: bold;">3. Drink:</label>
            <div class="dedication-type-selector">
                <label class="dedication-radio"><input type="radio" name="modal_bd_drink" value="Tea"><span class="radio-label">🍵 Tea</span></label>
                <label class="dedication-radio"><input type="radio" name="modal_bd_drink" value="Coffee"><span class="radio-label">☕ Coffee</span></label>
                <label class="dedication-radio"><input type="radio" name="modal_bd_drink" value="Hot Chocolate"><span class="radio-label">🍫 Hot Chocolate</span></label>
            </div>
        </div>
        <div id="modal-bd-response" class="alert mt-2" style="display:none;"></div>
      </div>
      <div class="modal-footer" style="border-top: none;">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" id="btn-modal-bd-save" data-url="{$link->getModuleLink('productcustomizer', 'save')}" style="background-color: #9b59b6; border-color: #9b59b6; font-weight: bold;">Update Preferences</button>
      </div>
    </div>
  </div>
</div>