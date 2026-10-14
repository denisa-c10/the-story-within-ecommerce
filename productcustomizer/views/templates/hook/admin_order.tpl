<div class="card mt-2">
    <div class="card-header">
        <h3 class="card-title">
            <i class="material-icons">menu_book</i> {l s='Customer Dedications & Preferences' mod='productcustomizer'}
        </h3>
    </div>
    
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>{l s='Product Image' mod='productcustomizer'}</th>
                    <th>{l s='Product Name' mod='productcustomizer'}</th>
                    <th>{l s='Type' mod='productcustomizer'}</th> 
                    <th>{l s='Message / Preferences' mod='productcustomizer'}</th>
                    <th>{l s='Style Details' mod='productcustomizer'}</th>
                </tr>
            </thead>
            <tbody>
                {foreach from=$dedications item=dedication}
                    <tr>
                        <td>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                {if isset($dedication.product_image_url) && $dedication.product_image_url}
                                    <img src="{$dedication.product_image_url}" alt="Product" style="width: 50px; height: auto; border: 1px solid #ddd; padding: 2px; border-radius: 4px;">
                                {else}
                                    <img src="/magazinlicenta/modules/productcustomizer/views/img/edit_icon.png" alt="Edit Icon" style="width: 40px; height: 40px; object-fit: contain; opacity: 0.7;">
                                {/if}

                                {if (!isset($dedication.dedication_type) || $dedication.dedication_type != 'blind_date') && $dedication.background}
                                    <div style="width: 30px; height: 30px; background-image: url('{$dedication.background}'); background-size: cover; border: 1px solid #ccc; border-radius: 50%;" title="Background ales de client"></div>
                                {/if}
                            </div>
                        </td>
                        
                        <td style="vertical-align: middle;">
                            <strong>{$dedication.product_name}</strong>
                        </td>

                        <td style="vertical-align: middle;">
                            {if isset($dedication.dedication_type) && $dedication.dedication_type == 'blind_date'}
                                <span class="badge badge-pill" style="font-size: 13px; padding: 6px 10px; background-color: #9b59b6; color: white;">
                                    ✨ Blind Date
                                </span>
                            {elseif isset($dedication.dedication_type) && $dedication.dedication_type == 'card'}
                                <span class="badge badge-pill badge-primary" style="font-size: 13px; padding: 6px 10px; background-color: #9b59b6;">
                                    💌 Greeting card
                                </span>
                            {else}
                                <span class="badge badge-pill badge-info" style="font-size: 13px; padding: 6px 10px;">
                                    📖 On the book
                                </span>
                            {/if}
                        </td>

                        <td style="vertical-align: middle;">
                            {if isset($dedication.dedication_type) && $dedication.dedication_type == 'blind_date'}
                                <div style="background: #fdfbfd; border: 2px dashed #9b59b6; padding: 12px; border-radius: 8px; display: inline-block; min-width: 200px;">
                                    <div style="font-size: 14px; color: #333; line-height: 1.6; font-weight: 500;">
                                        {$dedication.message|nl2br nofilter}
                                    </div>
                                </div>
                            {else}
                                <div class="clickable-dedication" 
                                     data-full-img="{$dedication.background}" 
                                     style="
                                        padding: 10px; 
                                        border: 1px solid #ddd; 
                                        background-image: url('{$dedication.background}'); 
                                        background-size: cover;
                                        background-position: center;
                                        max-width: 300px;
                                        border-radius: 5px;
                                        cursor: pointer; 
                                        position: relative;"
                                     title="Click pentru a mări imaginea">
                                    
                                    <span style="
                                        font-family: {$dedication.font}; 
                                        color: {$dedication.color}; 
                                        font-weight: bold;
                                        background: rgba(255,255,255,0.9);
                                        padding: 5px 8px;
                                        border-radius: 3px;
                                        display: inline-block;">
                                        {$dedication.message|nl2br}
                                    </span>
                                    
                                    <div class="zoom-icon-overlay" style="position: absolute; bottom: 5px; right: 5px; background: rgba(255,255,255,0.7); border-radius: 50%; padding: 3px; display: none;">
                                        <i class="material-icons" style="font-size: 16px;">zoom_in</i>
                                    </div>
                                </div>
                            {/if}
                        </td>
                        
                        <td style="vertical-align: middle;">
                            {if isset($dedication.dedication_type) && $dedication.dedication_type == 'blind_date'}
                                <span class="text-muted" style="font-style: italic;">No style required</span>
                            {else}
                                <span class="badge badge-info mb-1">Font: {$dedication.font}</span><br>
                                <span class="badge badge-secondary" style="background:{$dedication.color}; color:#fff; text-shadow: 1px 1px 0 #000;">Color: {$dedication.color}</span>
                            {/if}
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>

<div id="dedicationModal" class="dedication-modal">
  <span class="dedication-modal-close">&times;</span>
  <img class="dedication-modal-content" id="imgFull">
</div>

{literal}
<style>
    .dedication-modal {
        display: none; 
        position: fixed; 
        z-index: 10000; 
        padding-top: 50px; 
        left: 0;
        top: 0;
        width: 100%; 
        height: 100%; 
        background-color: rgba(0,0,0,0.8); 
    }
    .dedication-modal-content {
        margin: auto;
        display: block;
        max-width: 80%; 
        max-height: 80vh; 
        border: 3px solid #fff;
        border-radius: 8px;
        box-shadow: 0 5px 25px rgba(0,0,0,0.5);
        object-fit: contain;
        animation-name: zoom;
        animation-duration: 0.3s;
    }
    @keyframes zoom {
        from {transform: scale(0.8); opacity: 0;} 
        to {transform: scale(1); opacity: 1;}
    }
    .dedication-modal-close {
        position: absolute;
        top: 20px;
        right: 40px;
        color: #fff;
        font-size: 50px;
        font-weight: bold;
        transition: 0.3s;
        cursor: pointer;
    }
    .dedication-modal-close:hover {
        color: #9b59b6;
    }
    .clickable-dedication {
        transition: transform 0.2s;
    }
    .clickable-dedication:hover {
        transform: scale(1.02);
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }
    .clickable-dedication:hover .zoom-icon-overlay {
        display: block !important;
    }
</style>

<script>
    $(document).ready(function() {
        var $modal = $('#dedicationModal');
        var $modalImg = $('#imgFull');

        $('.clickable-dedication').on('click', function() {
            var bgUrl = $(this).data('full-img');
            if (bgUrl && bgUrl.trim() !== '') {
                $modalImg.attr('src', bgUrl);
                $modal.fadeIn('fast');
            } else {
                alert('Aceasta dedicatie nu are o imagine de fundal.');
            }
        });

        $('.dedication-modal-close').on('click', function() {
            $modal.fadeOut('fast');
        });

        $modal.on('click', function(e) {
            if (e.target.id === 'dedicationModal') {
                $modal.fadeOut('fast');
            }
        });
    });
</script>
{/literal}