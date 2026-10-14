<?php

class ProductCustomizerSaveModuleFrontController extends ModuleFrontController
{
    public $ajax = true;

    public function displayAjax()
    {
        header('Content-Type: application/json');

        $action = Tools::getValue('action');

        if ($action === 'deleteDedication') {
            $this->ajaxDie(json_encode($this->deleteDedication()));
        }

        $this->ajaxDie(json_encode($this->saveDedication()));
    }

    private function ensureCart()
    {
        if (!$this->context->cart->id) {
            $this->context->cart->add();
            $this->context->cookie->id_cart = (int)$this->context->cart->id;
        }
        return $this->context->cart;
    }

    private function saveDedication()
    {
        $cart = $this->ensureCart();

        $id_dedication = (int)Tools::getValue('id_dedication', 0);
        $id_product = (int)Tools::getValue('id_product', 0);
        $id_product_attribute = (int)Tools::getValue('id_product_attribute', 0);
        $message = (string)Tools::getValue('message', '');

        $font = (string)Tools::getValue('font', 'Arial');
        $color = (string)Tools::getValue('color', '#000000');
        $background = (string)Tools::getValue('background', '');

        // --- 1. NOU: Prindem tipul de dedicație (card sau book) ---
        $dedication_type = (string)Tools::getValue('dedication_type', 'card');

        if (!$id_product || trim($message) === '') {
            return ['success' => false, 'message' => 'Te rugăm să scrii un mesaj.'];
        }

        // --- 2. NOU: Logica de Upload a imaginii din PC ---
        if (isset($_FILES['custom_bg_image']) && $_FILES['custom_bg_image']['error'] === UPLOAD_ERR_OK) {
            $allowed_types = ['image/jpeg', 'image/png', 'image/jpg'];

            // Verificăm dacă e imagine validă
            if (in_array($_FILES['custom_bg_image']['type'], $allowed_types)) {
                $ext = pathinfo($_FILES['custom_bg_image']['name'], PATHINFO_EXTENSION);

                // Generăm un nume unic pentru fișier (ex: img_cart_15_prod_2_123456.jpg)
                $file_name = 'img_cart_' . $cart->id . '_prod_' . $id_product . '_' . time() . '.' . $ext;

                // Folderul unde salvăm pozele (în interiorul modulului tău)
                $upload_dir = _PS_MODULE_DIR_ . 'productcustomizer/views/img/uploads/';

                // Creăm folderul dacă nu există
                if (!file_exists($upload_dir)) {
                    mkdir($upload_dir, 0777, true);
                }

                $destination = $upload_dir . $file_name;

                // Mutăm fișierul temporar în locația finală
                if (move_uploaded_file($_FILES['custom_bg_image']['tmp_name'], $destination)) {
                    // Dacă s-a urcat cu succes, suprascriem variabila $background cu link-ul către noua poză
                    // Astfel, poza custom se comportă în sistem exact ca una predefinită
                    $background = __PS_BASE_URI__ . 'modules/productcustomizer/views/img/uploads/' . $file_name;
                }
            }
        }

        $ok = false;
        $msg = '';

        // -------------------------------------------------------------
        // LOGICĂ SALVARE BAZA DE DATE
        // -------------------------------------------------------------
        if ($id_dedication > 0) {
            // UPDATE
            $ok = Db::getInstance()->update(
                'product_customizer_dedication',
                [
                    'message' => pSQL($message, true),
                    'font' => pSQL($font),
                    'color' => pSQL($color),
                    'background' => pSQL($background),
                    'dedication_type' => pSQL($dedication_type) // <--- Salvează tipul
                ],
                'id_dedication=' . (int)$id_dedication . ' AND id_cart=' . (int)$cart->id
            );
            $msg = 'Dedication updated!';
        } else {
            // INSERT
            $ok = Db::getInstance()->insert('product_customizer_dedication', [
                'id_cart' => (int)$cart->id,
                'id_product' => (int)$id_product,
                'id_product_attribute' => (int)$id_product_attribute,
                'message' => pSQL($message, true),
                'font' => pSQL($font),
                'color' => pSQL($color),
                'background' => pSQL($background),
                'dedication_type' => pSQL($dedication_type) // <--- Salvează tipul
            ]);
            $msg = 'Dedication saved!';
        }

        // 🔥 RECALCULARE PRET
        require_once(_PS_MODULE_DIR_ . 'productcustomizer/productcustomizer.php');
        $module = new ProductCustomizer();
        if (method_exists($module, 'checkAndFixFees')) {
            ProductCustomizer::$is_saving = false;
            $module->checkAndFixFees($cart);
        }

        return ['success' => (bool)$ok, 'message' => $msg];
    }
    private function deleteDedication()
    {
        $cart = $this->ensureCart();

        $id_dedication = (int)Tools::getValue('id_dedication', 0);
        if ($id_dedication <= 0) {
            return ['success' => false, 'message' => 'Missing dedication ID.'];
        }

        $ok = Db::getInstance()->delete(
            'product_customizer_dedication',
            'id_dedication=' . (int)$id_dedication . ' AND id_cart=' . (int)$cart->id
        );


        // 🔥 RECALCULARE PRET
        require_once(_PS_MODULE_DIR_ . 'productcustomizer/productcustomizer.php');
        $module = new ProductCustomizer();

        if (method_exists($module, 'checkAndFixFees')) {
            ProductCustomizer::$is_saving = false; // Resetăm manual flag-ul static
            $module->checkAndFixFees($cart);
        }

        $cart->save();

        return ['success' => (bool)$ok, 'message' => $ok ? 'Dedication deleted!' : 'Delete failed.'];
    }
}
