{if $id_product == 103}
    <div class="product-customizer-section mt-3 mb-4" style="background: #fdfbfd; border: 2px dashed #e5d1ff; border-radius: 12px; padding: 20px;">
        <h3 style="color: #9b59b6; font-weight: bold; text-align: center; margin-bottom: 5px;">✨ Build Your Blind Date ✨</h3>
        <p class="text-muted text-center mb-4" style="font-size: 14px;">Tell us your vibe, and we'll match you with the perfect secret book!</p>

        <div class="form-group mb-4">
            <label style="font-weight: bold; font-size: 15px;">1. Choose your Favorite Genre (Pick 1):</label>
            <div class="dedication-type-selector mt-2">
                <label class="dedication-radio"><input type="radio" name="bd_genre" value="Romance" checked><span class="radio-label">💖 Romance</span></label>
                <label class="dedication-radio"><input type="radio" name="bd_genre" value="Fantasy"><span class="radio-label">🐉 Fantasy</span></label>
                <label class="dedication-radio"><input type="radio" name="bd_genre" value="Thriller / Mystery"><span class="radio-label">🕵️‍♀️ Thriller / Mystery</span></label>
                <label class="dedication-radio"><input type="radio" name="bd_genre" value="Historical Fiction"><span class="radio-label">🕰️ Historical Fiction</span></label>
            </div>
        </div>

        <div class="form-group mb-4">
            <label style="font-weight: bold; font-size: 15px;">2. What are your favorite Tropes? (Pick up to 3):</label>
            <div class="dedication-type-selector mt-2" id="tropes-container">
                <label class="dedication-checkbox"><input type="checkbox" name="bd_tropes" value="Enemies to Lovers"><span class="radio-label">Enemies to Lovers</span></label>
                <label class="dedication-checkbox"><input type="checkbox" name="bd_tropes" value="Dark Academia"><span class="radio-label">Dark Academia</span></label>
                <label class="dedication-checkbox"><input type="checkbox" name="bd_tropes" value="Slow Burn"><span class="radio-label">Slow Burn</span></label>
                <label class="dedication-checkbox"><input type="checkbox" name="bd_tropes" value="Plot Twist"><span class="radio-label">Massive Plot Twist</span></label>
                <label class="dedication-checkbox"><input type="checkbox" name="bd_tropes" value="Grumpy x Sunshine"><span class="radio-label">Grumpy x Sunshine</span></label>
                <label class="dedication-checkbox"><input type="checkbox" name="bd_tropes" value="Found Family"><span class="radio-label">Found Family</span></label>
            </div>
            <small class="text-danger" id="tropes-warning" style="display:none;">Please select a maximum of 3 tropes!</small>
        </div>

        <div class="form-group mb-4">
            <label style="font-weight: bold; font-size: 15px;">3. Choose your Cozy Drink:</label>
            <div class="dedication-type-selector mt-2">
                <label class="dedication-radio"><input type="radio" name="bd_drink" value="Tea" checked><span class="radio-label">🍵 Herbal/Black Tea</span></label>
                <label class="dedication-radio"><input type="radio" name="bd_drink" value="Coffee"><span class="radio-label">☕ Artisan Coffee</span></label>
                <label class="dedication-radio"><input type="radio" name="bd_drink" value="Hot Chocolate"><span class="radio-label">🍫 Hot Chocolate</span></label>
            </div>
        </div>

        <button type="button" id="btn-save-blind-date" class="btn btn-primary btn-block" data-url="{$ajax_url}" data-id-product="{$id_product}" style="background-color: #9b59b6; border-color: #9b59b6; font-size: 16px; padding: 12px; font-weight: bold; border-radius: 8px;">
            Lock in my preferences 🔒
        </button>
        <div id="blind-date-response" class="alert mt-3" style="display:none;"></div>
    </div>

{else}
    <button type="button" id="toggleCustomization" class="btn btn-secondary mb-3" style="background-color: #9b59b6; border-color: #9b59b6; color: white;">
        {l s='Customize your book' mod='productcustomizer'}
    </button>

    <div id="productCustomizationSection" style="display:none;">
        <div class="product-customizer-section mt-3">
            <div class="card product-customization">
                <div class="card-header">
                    <h3 class="card-title h5">{l s='Product Customization' mod='productcustomizer'}</h3>
                </div>

                <div class="card-body">
                    <input type="hidden" id="edit_dedication_id" value="{if isset($dedication_edit) && $dedication_edit}{$dedication_edit.id_dedication}{else}0{/if}">
                    
                    <div class="custom-dedication-extra-options mb-3">
                        <label class="dedication-title" style="font-weight: bold;">{l s='Where should we write the text?' mod='productcustomizer'}</label>
                        <div class="dedication-type-selector mt-2">
                            <label class="dedication-radio">
                                <input type="radio" name="dedication_type" value="card" checked>
                                <span class="radio-label">💌 {l s='Greeting card attached' mod='productcustomizer'}</span>
                            </label>
                            <label class="dedication-radio">
                                <input type="radio" name="dedication_type" value="book">
                                <span class="radio-label">📖 {l s='Dedication on the first page of the book' mod='productcustomizer'}</span>
                            </label>
                        </div>
                    </div>

                    <div class="form-group mt-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <label for="custom_dedication_text" style="font-weight: bold; margin: 0;">{l s='Your message:' mod='productcustomizer'}</label>
                            <button type="button" id="btn-inspire-me" class="btn btn-sm" style="background-color: #f8f1ff; color: #9b59b6; border: 1px solid #e5d1ff; border-radius: 20px; font-weight: bold; padding: 4px 12px; transition: all 0.2s;">
                                ✨ Inspire Me
                            </button>
                        </div>

                        <div id="quotes-library" style="display: none; background: #fff; border: 1px solid #e5d1ff; border-radius: 8px; padding: 15px; margin-bottom: 15px; max-height: 250px; overflow-y: auto; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
                            <p class="text-muted small mb-3">{l s='Click on a quote to add it to your dedication:' mod='productcustomizer'}</p>
                            
                            <h6 style="color: #9b59b6; font-weight: bold; margin-bottom: 8px; border-bottom: 1px solid #f0e6f7; padding-bottom: 5px; font-size: 13px;">💖 {l s='Romance & Love' mod='productcustomizer'}</h6>
                            <div class="quote-item">{l s='"You are my sun, my moon, and all my stars." - E.E. Cummings' mod='productcustomizer'}</div>
                            <div class="quote-item">{l s='"I would rather share one lifetime with you than face all the ages of this world alone." - J.R.R. Tolkien' mod='productcustomizer'}</div>
                            <div class="quote-item">{l s='"Whatever our souls are made of, his and mine are the same." - Emily Brontë' mod='productcustomizer'}</div>

                            <h6 style="color: #9b59b6; font-weight: bold; margin-top: 15px; margin-bottom: 8px; border-bottom: 1px solid #f0e6f7; padding-bottom: 5px; font-size: 13px;">👯‍♀️ {l s='Friendship' mod='productcustomizer'}</h6>
                            <div class="quote-item">{l s='"There is nothing I would not do for those who are really my friends." - Jane Austen' mod='productcustomizer'}</div>
                            <div class="quote-item">{l s='"A good friend is like a four-leaf clover; hard to find and lucky to have." - Irish Proverb' mod='productcustomizer'}</div>
                            <div class="quote-item">{l s='"Friendship is born at that moment when one person says to another: \'What! You too? I thought I was the only one.\'" - C.S. Lewis' mod='productcustomizer'}</div>

                            <h6 style="color: #9b59b6; font-weight: bold; margin-top: 15px; margin-bottom: 8px; border-bottom: 1px solid #f0e6f7; padding-bottom: 5px; font-size: 13px;">🎂 {l s='Birthdays' mod='productcustomizer'}</h6>
                            <div class="quote-item">{l s='"Count your age by friends, not years. Count your life by smiles, not tears." - John Lennon' mod='productcustomizer'}</div>
                            <div class="quote-item">{l s='Wishing you a day filled with happiness and a year filled with joy. Happy Birthday!' mod='productcustomizer'}</div>
                            
                            <h6 style="color: #9b59b6; font-weight: bold; margin-top: 15px; margin-bottom: 8px; border-bottom: 1px solid #f0e6f7; padding-bottom: 5px; font-size: 13px;">📚 {l s='Book Lovers' mod='productcustomizer'}</h6>
                            <div class="quote-item">{l s='"A reader lives a thousand lives before he dies. The man who never reads lives only one." - George R.R. Martin' mod='productcustomizer'}</div>
                            <div class="quote-item">{l s='"Between the pages of a book is a lovely place to be." - Unknown' mod='productcustomizer'}</div>
                        </div>

                        <textarea id="custom_dedication_text" class="form-control" rows="3" maxlength="250" placeholder="Ex: For Mary, with love...">{if isset($dedication_edit) && $dedication_edit}{$dedication_edit.message|escape:'html'}{/if}</textarea>
                        <small class="float-xs-right text-muted"><span id="chars_count">0</span>/250 characters</small>
                    </div>

                    <div class="row mt-2">
                        <div class="col-md-6 form-group">
                            <label style="font-weight: bold;">{l s='Choose font:' mod='productcustomizer'}</label>
                            <select id="fontSelect" class="form-control">
                                <option value="Arial">Arial</option>
                                <option value="Georgia">Georgia</option>
                                <option value="cursive">Cursive</option>
                                <option value="Times New Roman">Times New Roman</option>
                            </select>
                        </div>
                        <div class="col-md-6 form-group">
                            <label style="font-weight: bold;">{l s='Choose color:' mod='productcustomizer'}</label>
                            <input type="color" id="colorPicker" class="form-control" value="{if isset($dedication_edit) && $dedication_edit}{$dedication_edit.color|escape:'html'}{else}#000000{/if}" style="height: 40px;">
                        </div>
                    </div>

                    <div class="form-group mt-3 pb-3 border-bottom">
                        <label style="font-weight: bold;">{l s='Choose background or upload your own:' mod='productcustomizer'}</label>
                        <div class="d-flex align-items-center flex-wrap mt-2" style="gap: 10px;">
                            <img src="{$module_dir}views/img/bg_flower.png" class="backgroundOption" data-bg="{$module_dir}views/img/bg_flower.png" style="width:50px; height:50px; cursor:pointer; border:1px solid #ccc; border-radius:5px; object-fit:cover;" />
                            <img src="{$module_dir}views/img/bg_heart.png" class="backgroundOption" data-bg="{$module_dir}views/img/bg_heart.png" style="width:50px; height:50px; cursor:pointer; border:1px solid #ccc; border-radius:5px; object-fit:cover;" />
                            <img src="{$module_dir}views/img/bg_simple.png" class="backgroundOption" data-bg="{$module_dir}views/img/bg_simple.png" style="width:50px; height:50px; cursor:pointer; border:1px solid #ccc; border-radius:5px; object-fit:cover;" />
                            <img src="{$module_dir}views/img/bg_stars.png" class="backgroundOption" data-bg="{$module_dir}views/img/bg_stars.png" style="width:50px; height:50px; cursor:pointer; border:1px solid #ccc; border-radius:5px; object-fit:cover;" />

                            <label for="dedication_bg_image" class="btn btn-outline-primary mb-0" style="cursor: pointer; border-color: #9b59b6; color: #9b59b6;">
                                <i class="material-icons">cloud_upload</i> Upload from PC
                            </label>
                            <input type="file" id="dedication_bg_image" name="dedication_bg_image" accept="image/png, image/jpeg" style="display:none;">
                        </div>
                        <span id="file-name-display" class="d-block mt-2 text-muted" style="font-size: 12px; font-style: italic;"></span>
                    </div>

                    <div class="mt-3">
                        <label style="font-weight: bold;">{l s='Live Preview:' mod='productcustomizer'}</label>
                        <div id="dedicationPreview" style="min-height:250px; background-size:cover; background-position:center; display:flex; align-items:center; justify-content:center; text-align:center; white-space:pre-wrap; font-size: 22px;">
    {if isset($dedication_edit) && $dedication_edit}{$dedication_edit.message|escape:'html'}{else}Your message will appear here{/if}
</div>
                    </div>

                    <div class="clearfix mt-3">
                        <button type="button" id="btn-save-dedication" class="btn btn-primary float-xs-right" data-url="{$ajax_url}" data-id-product="{$id_product}" style="background-color: #9b59b6; border-color: #9b59b6;">
                            {if isset($dedication_edit) && $dedication_edit}{l s='Update Dedication' mod='productcustomizer'}{else}{l s='Save Dedication' mod='productcustomizer'}{/if}
                        </button>
                    </div>
                    <div id="dedication-response" class="alert mt-2" style="display:none;" role="alert"></div>
                </div>
            </div>
        </div>
    </div>
{/if}