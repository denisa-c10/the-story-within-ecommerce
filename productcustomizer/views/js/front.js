$(document).ready(function () {

    /* =================================================================================
       1. FUNCȚIILE PRINCIPALE (Aici definim cum se comportă pagina)
       ================================================================================= */

    // Funcția care actualizează Live Preview-ul în timp real
    function applyProductPreview() {
        var text = $('#custom_dedication_text').val() || '';
        $('#chars_count').text(text.length);

        // Folosim textul introdus sau un placeholder magic
        $('#dedicationPreview').text(text || 'Your message will appear here...');

        var font = $('#fontSelect').val() || 'Arial';
        var color = $('#colorPicker').val() || '#000000';
        var bg = $('.backgroundOption.selected').data('bg') || '';

        // DETECTĂM TIPUL ALES: card (felicitare) sau book (fila de carte)
        var type = $('input[name="dedication_type"]:checked').val() || 'card';

        var previewBox = document.getElementById('dedicationPreview');
        if (previewBox) {
            // 1. SCHIMBĂM SUPORTUL (Aspectul vizual)
            if (type === 'book') {
                $(previewBox).addClass('preview-mode-book').removeClass('preview-mode-card');
            } else {
                $(previewBox).addClass('preview-mode-card').removeClass('preview-mode-book');
            }

            // 2. APLICĂM CULOAREA
            previewBox.style.setProperty('color', color, 'important');

            // 3. APLICĂM FONTUL (Special pentru Cursive)
            if (font === 'cursive') {
                $(previewBox).addClass('font-cursive');
            } else {
                $(previewBox).removeClass('font-cursive');
                previewBox.style.setProperty('font-family', font, 'important');
            }

            // 4. GESTIONĂM FUNDALUL CUSTOM (Dacă există poze alese)
            if (bg !== '') {
                previewBox.style.setProperty('background-image', 'url(' + bg + ')', 'important');
                previewBox.style.setProperty('background-size', 'cover', 'important');
            } else {
                // Dacă e mod carte, păstrăm textura de hârtie veche, altfel ștergem fundalul
                if (type !== 'book') {
                    previewBox.style.setProperty('background-image', 'none', 'important');
                } else {
                    previewBox.style.removeProperty('background-image'); // Revine la textura de hârtie veche
                }
            }
        }
    }

    // ADĂUGĂM UN LISTENER PENTRU SCHIMBAREA RADIO BUTTONS (Card vs Book)
    $(document).on('change', 'input[name="dedication_type"]', function () {
        applyProductPreview();
    });


    /* =================================================================================
       2. ASCULTĂTORI (LISTENERS) PENTRU LIVE PREVIEW
       ================================================================================= */

    // Arată/ascunde secțiunea de personalizare
    $('#toggleCustomization').on('click', function () {
        $('#productCustomizationSection').slideToggle();
    });

    // Ascultăm orice modificare făcută de client pentru a schimba Live Preview-ul
    $(document).on('change', 'input[name="dedication_type"]', applyProductPreview);
    $(document).on('input', '#custom_dedication_text', applyProductPreview);
    $(document).on('change', '#fontSelect', applyProductPreview);
    $(document).on('input', '#colorPicker', applyProductPreview);

    // Când clientul alege o imagine de fundal predefinită
    $(document).on('click', '.backgroundOption', function () {
        $('.backgroundOption').removeClass('selected');
        $(this).addClass('selected');

        // Resetăm input-ul de PC ca să nu existe conflicte
        var fileInput = document.getElementById('dedication_bg_image');
        if (fileInput) fileInput.value = '';
        var display = document.getElementById('file-name-display');
        if (display) display.innerText = '';

        applyProductPreview();
    });

    // Când clientul încarcă o imagine din PC
    $(document).on('change', '#dedication_bg_image', function () {
        var file = this.files[0];
        var previewBoxProd = document.getElementById('dedicationPreview');
        var fileNameDisplayProd = document.getElementById('file-name-display');

        if (file && previewBoxProd) {
            if (fileNameDisplayProd) fileNameDisplayProd.innerText = file.name;
            if (!file.type.match('image.*')) {
                alert('Te rugăm să selectezi un fișier imagine valid (JPG, PNG).');
                this.value = '';
                return;
            }
            var reader = new FileReader();
            reader.onload = function (e) {
                previewBoxProd.style.setProperty('background-image', "url('" + e.target.result + "')", 'important');
                previewBoxProd.style.setProperty('background-size', 'cover', 'important');
                $('.backgroundOption').removeClass('selected'); // Deselectăm imaginile predefinite
            };
            reader.readAsDataURL(file);
        } else {
            if (fileNameDisplayProd) fileNameDisplayProd.innerText = 'Niciun fișier selectat';
            applyProductPreview();
        }
    });


    /* =================================================================================
       3. SALVAREA DEDICAȚIEI (AJAX)
       ================================================================================= */

    $('#btn-save-dedication').on('click', function (e) {
        e.preventDefault();

        var $btn = $(this);
        var url = $btn.data('url');
        var id_product = $btn.data('id-product');
        var message = $('#custom_dedication_text').val();
        var $msg = $('#dedication-response');

        $msg.hide().removeClass('alert-success alert-danger');

        if (!message || !message.trim()) {
            $msg.addClass('alert-danger').text('Please enter a message.').show();
            return;
        }

        $btn.prop('disabled', true).text('Saving...');

        var formData = new FormData();
        formData.append('ajax', 1);
        formData.append('action', 'saveDedication');
        formData.append('id_dedication', $('#edit_dedication_id').val() || 0);
        formData.append('id_product', id_product);
        formData.append('id_product_attribute', $('#id_product_attribute').val() || 0);
        formData.append('message', message);
        formData.append('font', $('#fontSelect').val() || 'Arial');
        formData.append('color', $('#colorPicker').val() || '#000000');
        formData.append('background', $('.backgroundOption.selected').data('bg') || '');
        formData.append('dedication_type', $('input[name="dedication_type"]:checked').val() || 'card');

        var fileInputProd = document.getElementById('dedication_bg_image');
        if (fileInputProd && fileInputProd.files[0]) {
            formData.append('custom_bg_image', fileInputProd.files[0]);
        }

        $.ajax({
            type: 'POST', url: url, dataType: 'json', data: formData, processData: false, contentType: false,
            success: function (data) {
                $btn.prop('disabled', false).text('Save Dedication');
                if (data && data.success) {
                    $msg.addClass('alert-success').text(data.message).show();
                    location.reload(); // Reîncărcăm pentru a adăuga în coș
                } else {
                    $msg.addClass('alert-danger').text(data.message ? data.message : 'Server error.').show();
                }
            },
            error: function () {
                $btn.prop('disabled', false).text('Save Dedication');
                $msg.addClass('alert-danger').text('Server error.').show();
            }
        });
    });


    /* =================================================================================
       4. LIBRĂRIA DE CITATE ("INSPIRE ME")
       ================================================================================= */

    $('#btn-inspire-me').on('click', function () {
        $('#quotes-library').slideToggle('fast');
    });

    $('.quote-item').on('click', function () {
        var quoteText = $(this).text();
        $('#custom_dedication_text').val(quoteText);
        $('#quotes-library').slideUp('fast');
        applyProductPreview(); // Actualizăm preview-ul instant
    });


    /* =================================================================================
       5. BLIND DATE WITH A BOOK (ID 103)
       ================================================================================= */

    // Limităm selecția la maxim 3 Tropes
    $('input[name="bd_tropes"]').on('change', function () {
        var checkedCount = $('input[name="bd_tropes"]:checked').length;
        if (checkedCount > 3) {
            $(this).prop('checked', false);
            $('#tropes-warning').fadeIn().delay(3000).fadeOut();
        }
    });

    // Salvare Blind Date
    $('#btn-save-blind-date').on('click', function (e) {
        e.preventDefault();
        var $btn = $(this);
        var $msg = $('#blind-date-response');
        var tropes = [];

        $('input[name="bd_tropes"]:checked').each(function () { tropes.push($(this).val()); });

        if (tropes.length === 0) {
            $msg.removeClass('alert-success').addClass('alert-danger').text('Please select at least 1 trope!').show();
            return;
        }

        var bdMessage = "GENRE: " + $('input[name="bd_genre"]:checked').val() + "\n" +
            "TROPES: " + tropes.join(', ') + "\n" +
            "DRINK: " + $('input[name="bd_drink"]:checked').val();

        $btn.prop('disabled', true).text('Saving...');

        var formData = new FormData();
        formData.append('ajax', 1);
        formData.append('action', 'saveDedication');
        formData.append('id_dedication', 0);
        formData.append('id_product', $btn.data('id-product'));
        formData.append('message', bdMessage);
        formData.append('font', 'Georgia');
        formData.append('color', '#000000');
        formData.append('dedication_type', 'blind_date');

        $.ajax({
            type: 'POST', url: $btn.data('url'), dataType: 'json', data: formData, processData: false, contentType: false,
            success: function (data) {
                $btn.prop('disabled', false).text('Preferences Saved! ✔️');
                $btn.css({ 'background-color': '#2ecc71', 'border-color': '#2ecc71' });
                if (data && data.success) {
                    $msg.removeClass('alert-danger').addClass('alert-success').html('<strong>Perfect!</strong> We saved your vibe. Now click the <b>Add to Cart</b> button!').show();
                }
            }
        });
    });


    /* =================================================================================
       6. MODAL COȘ (Editare & Ștergere Dedicații + Blind Date)
       ================================================================================= */

    // Deschide modalul de editare dedicatie simpla
    $(document).on('click', '.edit-dedication-btn', function () {
        var $btn = $(this);
        var type = $btn.data('type') || 'card';
        var bg = $btn.data('background') || '';

        $('#modal_edit_id').val($btn.data('id'));
        $('#modal_product_id').val($btn.data('id-product'));
        $('#modal_product_attribute').val($btn.data('id-attribute') || 0);
        $('#modal_edit_message').val($btn.data('message') || '');
        $('#modal_edit_font').val($btn.data('font') || 'Arial');
        $('#modal_edit_color').val($btn.data('color') || '#000000');
        $('#modal_edit_background').val(bg);

        $('input[name="modal_dedication_type"][value="' + type + '"]').prop('checked', true);

        // Reset imagine PC modal
        $('#modal_custom_bg_image').val('');
        $('#modal-file-name').text('');
        $('#modal_current_custom_bg_info').hide();
        $('.modalBgOption').removeClass('selected').css('border', '1px solid #ccc');

        if (bg) {
            var isPredefinedBg = false;
            $('.modalBgOption').each(function () {
                if ($(this).data('bg') === bg) {
                    $(this).addClass('selected').css('border', '2px solid #007bff');
                    isPredefinedBg = true;
                }
            });
            if (!isPredefinedBg && bg.trim() !== '') $('#modal_current_custom_bg_info').show();
        }
        $('#editDedicationModal').modal('show');
    });

    // Salvare editare dedicație (Modal)
    $('#btn-modal-save').on('click', function () {
        var $btn = $(this);
        var $resp = $('#modal-response');
        var message = $('#modal_edit_message').val();

        $resp.hide().removeClass('alert-success alert-danger');
        if (!message || !message.trim()) {
            $resp.addClass('alert-danger').text('Mesajul este obligatoriu.').show();
            return;
        }

        $btn.prop('disabled', true).text('Saving...');
        var formData = new FormData();
        formData.append('ajax', 1);
        formData.append('action', 'saveDedication');
        formData.append('id_dedication', $('#modal_edit_id').val());
        formData.append('id_product', $('#modal_product_id').val());
        formData.append('id_product_attribute', $('#modal_product_attribute').val() || 0);
        formData.append('message', message);
        formData.append('font', $('#modal_edit_font').val() || 'Arial');
        formData.append('color', $('#modal_edit_color').val() || '#000000');
        formData.append('background', $('#modal_edit_background').val() || '');
        formData.append('dedication_type', $('input[name="modal_dedication_type"]:checked').val() || 'card');

        var fileInputModal = document.getElementById('modal_custom_bg_image');
        if (fileInputModal && fileInputModal.files[0]) formData.append('custom_bg_image', fileInputModal.files[0]);

        $.ajax({
            type: 'POST', url: $btn.data('url'), dataType: 'json', data: formData, processData: false, contentType: false,
            success: function (data) {
                if (data && data.success) {
                    $resp.addClass('alert-success').text(data.message).show();
                    setTimeout(function () { location.reload(); }, 400);
                } else {
                    $btn.prop('disabled', false).text('Save changes');
                    $resp.addClass('alert-danger').text(data.message ? data.message : 'Eroare.').show();
                }
            }
        });
    });

    // Deschide Modal Editare Blind Date
    $(document).on('click', '.edit-blind-date-btn', function () {
        var msg = $(this).data('message');
        $('#modal_bd_id').val($(this).data('id'));
        $('#modal_bd_product').val($(this).data('id-product'));

        $('input[name="modal_bd_genre"], input[name="modal_bd_tropes"], input[name="modal_bd_drink"]').prop('checked', false);

        var genreMatch = msg.match(/GENRE:\s*([^\n<]+)/);
        var drinkMatch = msg.match(/DRINK:\s*([^\n<]+)/);
        var tropesMatch = msg.match(/TROPES:\s*([^\n<]+)/);

        if (genreMatch) $('input[name="modal_bd_genre"][value="' + genreMatch[1].trim() + '"]').prop('checked', true);
        if (drinkMatch) $('input[name="modal_bd_drink"][value="' + drinkMatch[1].trim() + '"]').prop('checked', true);
        if (tropesMatch) {
            tropesMatch[1].split(',').forEach(function (t) {
                $('input[name="modal_bd_tropes"][value="' + t.trim() + '"]').prop('checked', true);
            });
        }
    });

    // Limitare Tropes Modal Blind Date
    $('input[name="modal_bd_tropes"]').on('change', function () {
        if ($('input[name="modal_bd_tropes"]:checked').length > 3) {
            $(this).prop('checked', false);
            alert('Please select a maximum of 3 tropes!');
        }
    });

    // Salvare Modificari Modal Blind Date
    $('#btn-modal-bd-save').on('click', function () {
        var $btn = $(this);
        var tropes = [];
        $('input[name="modal_bd_tropes"]:checked').each(function () { tropes.push($(this).val()); });

        if (tropes.length === 0) {
            $('#modal-bd-response').removeClass('alert-success').addClass('alert-danger').text('Select at least 1 trope!').show();
            return;
        }

        $btn.prop('disabled', true).text('Updating...');
        var bdMessage = "GENRE: " + $('input[name="modal_bd_genre"]:checked').val() + "\n" +
            "TROPES: " + tropes.join(', ') + "\n" +
            "DRINK: " + $('input[name="modal_bd_drink"]:checked').val();

        var formData = new FormData();
        formData.append('ajax', 1);
        formData.append('action', 'saveDedication');
        formData.append('id_dedication', $('#modal_bd_id').val());
        formData.append('id_product', $('#modal_bd_product').val());
        formData.append('message', bdMessage);
        formData.append('dedication_type', 'blind_date');

        $.ajax({
            type: 'POST', url: $btn.data('url'), dataType: 'json', data: formData, processData: false, contentType: false,
            success: function (data) {
                if (data && data.success) location.reload();
            }
        });
    });

    // Ștergere Dedicație (Cart)
    $(document).on('click', '.delete-dedication-btn', function () {
        if (!confirm('Are you sure you want to delete this dedication?')) return;
        $.ajax({
            type: 'POST', url: $(this).data('url'), dataType: 'json',
            data: { ajax: 1, action: 'deleteDedication', id_dedication: $(this).data('id') },
            success: function (data) { if (data && data.success) location.reload(); }
        });
    });

    // Rulăm Preview-ul o dată la încărcarea paginii (dacă există elementul)
    applyProductPreview();

}); // Sfârșitul $(document).ready