<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class ProductCustomizer extends Module
{
    public static $is_saving = false;
    public function __construct()
    {
        $this->name = 'productcustomizer';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'Denisa Coman';
        $this->need_instance = 0;
        $this->ps_versions_compliancy = ['min' => '1.7.8', 'max' => '9.99.99'];
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->trans('ProductCustomizer', [], 'Modules.ProductCustomizer.Admin');
        $this->description = $this->trans('Add a custom dedication on books.', [], 'Modules.ProductCustomizer.Admin');
        $this->confirmUninstall = $this->trans('Are you sure you want to uninstall?', [], 'Modules.ProductCustomizer.Admin');

        if (!Configuration::get('ProductCustomizer')) {
            $this->warning = $this->trans('No name provided', [], 'Modules.ProductCustomizer.Admin');
        }
    }

    public function install()
    {
        if (Shop::isFeatureActive()) {
            Shop::setContext(Shop::CONTEXT_ALL);
        }

        Configuration::updateValue('PRODUCTCUSTOMIZER_PRICE', 5.00);
        Configuration::updateValue('PRODUCTCUSTOMIZER_DISCOUNT', 3.50);

        return (
            parent::install()
            && $this->registerHook('displayProductAdditionalInfo')
            && $this->registerHook('displayShoppingCart')
            && $this->registerHook('actionCartUpdateQuantity')
            && $this->registerHook('actionCartSave')
            && $this->registerHook('displayAdminOrder')
            && $this->registerHook('header')
            && Configuration::updateValue('ProductCustomizer', 'my module')
            && $this->createTable()
            && $this->createFeeProduct()
        );
    }

    public function uninstall()
    {

        return (
            parent::uninstall()
            && Configuration::deleteByName('ProductCustomizer')
            && Configuration::deleteByName('PRODUCTCUSTOMIZER_PRICE')
            && Configuration::deleteByName('PRODUCTCUSTOMIZER_DISCOUNT')
            && $this->deleteTable()
        );
    }

    protected function createTable()
    {
        $sql = "CREATE TABLE IF NOT EXISTS `" . _DB_PREFIX_ . "product_customizer_dedication` (
            `id_dedication` int(11) NOT NULL AUTO_INCREMENT,
            `id_cart` int(11) NOT NULL,
            `id_product` int(11) NOT NULL,
            `id_product_attribute` int(11) NOT NULL DEFAULT '0',
            `message` text,
            `font` varchar(50) DEFAULT 'Arial',
            `color` varchar(20) DEFAULT '#000000',
            `background` varchar(255) DEFAULT '',
            `dedication_type` varchar(50) DEFAULT 'card', 
            PRIMARY KEY (`id_dedication`)
        ) ENGINE=" . _MYSQL_ENGINE_ . " DEFAULT CHARSET=utf8;";

        return Db::getInstance()->execute($sql);
    }
    private function createFeeProduct()
    {
        // verificam daca produsul exista 
        $id_product = (int)Configuration::get('PRODUCTCUSTOMIZER_ID_PRODUCT');
        if ($id_product) {
            $product = new Product($id_product);
            if (Validate::isLoadedObject($product)) {
                return true;
            }
        }

        // cream produsul
        $product = new Product();
        $product->name = [(int)Configuration::get('PS_LANG_DEFAULT') => 'Serviciu Dedicație Personalizată'];
        $product->link_rewrite = [(int)Configuration::get('PS_LANG_DEFAULT') => 'serviciu-dedicatie'];
        $product->price = 0; // prețul de baza e 0  
        $product->active = 1;
        $product->visibility = 'none'; // ascundem sa nu apara in catalog
        $product->is_virtual = 1; // este un serviciu
        $product->id_category_default = 2;
        $product->redirect_type = '404';

        if ($product->add()) {
            // stoc infinit 
            StockAvailable::setQuantity($product->id, 0, 999999);
            // salvam ID-ul 
            Configuration::updateValue('PRODUCTCUSTOMIZER_ID_PRODUCT', $product->id);
            return true;
        }

        return false;
    }
    protected function deleteTable()
    {
        return Db::getInstance()->execute("DROP TABLE IF EXISTS `" . _DB_PREFIX_ . "product_customizer_dedication`");
    }

    // formular pe pagina produsului
    public function hookDisplayProductAdditionalInfo($params)
    {
        $id_product = (int)$params['product']['id_product'];
        $id_product_attribute = (int)Tools::getValue('id_product_attribute', 0);

        $dedicationToEdit = null;
        $dedication_id = (int)Tools::getValue('dedication_id');

        if ($dedication_id > 0) {
            $dedicationToEdit = Db::getInstance()->getRow(
                'SELECT * FROM `' . _DB_PREFIX_ . 'product_customizer_dedication`
             WHERE id_dedication=' . (int)$dedication_id . '
             AND id_cart=' . (int)$this->context->cart->id . '
             AND id_product=' . (int)$id_product . '
             LIMIT 1'
            );
        }

        $this->context->smarty->assign([
            'ajax_url' => $this->context->link->getModuleLink($this->name, 'save'),
            'id_product' => $id_product,
            'module_dir' => $this->_path,
            'dedication_edit' => $dedicationToEdit,  // pentru editare
        ]);

        return $this->fetch('module:' . $this->name . '/views/templates/hook/ProductCustomizer.tpl');
    }

    // afisare in cos
    public function hookDisplayShoppingCart($params)
    {
        $dedications = $this->getCartDedications();

        // add edit_url for each dedication (go back to product page)
        foreach ($dedications as &$d) {
            $productUrl = $this->context->link->getProductLink(
                (int)$d['id_product'],
                null,
                null,
                null,
                (int)$this->context->language->id,
                null,
                (int)$d['id_product_attribute']
            );

            // add dedication_id param
            $sep = (strpos($productUrl, '?') === false) ? '?' : '&';
            $d['edit_url'] = $productUrl . $sep . 'dedication_id=' . (int)$d['id_dedication'] . '#productCustomizationSection';
        }
        unset($d);

        $this->context->smarty->assign([
            'module_dir' => $this->_path,
            'ajax_url' => $this->context->link->getModuleLink($this->name, 'save'),
            'dedications' => $dedications,
        ]);

        return $this->fetch('module:' . $this->name . '/views/templates/hook/cart_dedications.tpl');
    }

    // stergere dedicatie cand se scade cantitatea
    public function hookActionCartUpdateQuantity($params)
    {
        // executam doar daca produsul e sters sau cantitatea e 0
        if ((int)$params['quantity'] <= 0) {
            $id_cart = (int)$params['cart']->id;
            $id_product = (int)$params['id_product'];
            $id_product_attribute = (int)$params['id_product_attribute'];

            // stergem dedicatiile acestui produs specific
            Db::getInstance()->delete(
                'product_customizer_dedication',
                'id_cart = ' . $id_cart . ' 
                 AND id_product = ' . $id_product . ' 
                 AND id_product_attribute = ' . $id_product_attribute
            );

            // recalculam pretul 
            $this->checkAndFixFees($params['cart']);
        }
    }
    public function hookHeader()
    {
        $this->context->controller->addJS($this->_path . 'views/js/front.js');
    }

    // preluare dedicatii valide pentru produsele aflate in cos
    public function getCartDedications()
    {
        $cart = $this->context->cart;
        if (!$cart) return [];

        $products = $cart->getProducts();
        $product_ids = array_map(function ($p) {
            return (int)$p['id_product'];
        }, $products);

        if (empty($product_ids)) return [];

        $sql = 'SELECT d.*, pl.name as product_name
            FROM `' . _DB_PREFIX_ . 'product_customizer_dedication` d
            LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl ON (d.id_product = pl.id_product AND pl.id_lang = ' . (int)$this->context->language->id . ')
            WHERE d.id_cart = ' . (int)$cart->id . '
            AND d.id_product IN (' . implode(',', $product_ids) . ')';

        return Db::getInstance()->executeS($sql);
    }


    // afisare dedicatii in dashboard-ul din Back Office
    public function hookDisplayAdminOrder($params)
    {
        $order = new Order((int)$params['id_order']);

        // logica de preluare a ID-urilor de produs si de cos
        $products = $order->getProducts();
        $product_ids = [];
        $cart_id = (int)$order->id_cart;

        foreach ($products as $product) {
            $product_ids[] = (int)$product['product_id'];
        }

        if (empty($product_ids)) {
            return '';
        }

        $product_ids_list = implode(',', array_unique($product_ids));

        // interogare SQL pentru a prelua dedicatiile valide 
        $dedications = Db::getInstance()->executeS('
        SELECT d.*, pl.name as product_name
        FROM `' . _DB_PREFIX_ . 'product_customizer_dedication` d
        LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl ON (d.id_product = pl.id_product AND pl.id_lang = ' . (int)$this->context->language->id . ')
        WHERE d.id_cart = ' . (int)$cart_id . ' 
        AND d.id_product IN (' . pSQL($product_ids_list) . ')
    ');

        if (empty($dedications)) {
            return '';
        }

        // trimitem datele catre template
        $this->context->smarty->assign([
            'dedications' => $dedications,
        ]);

        // returnam direct tabelul
        return $this->fetch('module:' . $this->name . '/views/templates/hook/admin_order.tpl');
    }



    //  metoda pentru CONFIGURE in lista de module
    public function getContent()
    {
        $output = '';

        // daca s-a apasat butonul de salvare
        if (Tools::isSubmit('submitProductCustomizer')) {
            $price = (float)Tools::getValue('PRODUCTCUSTOMIZER_PRICE');
            $discount = (float)Tools::getValue('PRODUCTCUSTOMIZER_DISCOUNT');

            // validare si salvare
            if (Validate::isFloat($price) && Validate::isFloat($discount)) {
                Configuration::updateValue('PRODUCTCUSTOMIZER_PRICE', $price);
                Configuration::updateValue('PRODUCTCUSTOMIZER_DISCOUNT', $discount);
                $output .= $this->displayConfirmation($this->trans('Settings updated', [], 'Admin.Notifications.Success'));
            } else {
                $output .= $this->displayError($this->trans('Invalid values', [], 'Admin.Notifications.Error'));
            }
        }

        // afiseaza formularul
        return $output . $this->renderForm();
    }


    // generam formularul folosind HelperForm
    public function renderForm()
    {
        $fields_form = [
            'form' => [
                'legend' => [
                    'title' => $this->trans('Dedication Pricing', [], 'Modules.ProductCustomizer.Admin'),
                    'icon' => 'icon-cogs',
                ],
                'input' => [
                    [
                        'type' => 'text',
                        'label' => $this->trans('Standard Price (First Dedication)', [], 'Modules.ProductCustomizer.Admin'),
                        'name' => 'PRODUCTCUSTOMIZER_PRICE',
                        'desc' => $this->trans('Price for a single dedication (e.g. 5.00).', [], 'Modules.ProductCustomizer.Admin'),
                        'col' => 3,
                        'suffix' => 'RON'
                    ],
                    [
                        'type' => 'text',
                        'label' => $this->trans('Discounted Price (Subsequent Dedications)', [], 'Modules.ProductCustomizer.Admin'),
                        'name' => 'PRODUCTCUSTOMIZER_DISCOUNT',
                        'desc' => $this->trans('Price for the 2nd, 3rd dedication onward (e.g. 3.50).', [], 'Modules.ProductCustomizer.Admin'),
                        'col' => 3,
                        'suffix' => 'RON'
                    ],
                ],
                'submit' => [
                    'title' => $this->trans('Save', [], 'Admin.Actions'),
                ],
            ],
        ];

        $helper = new HelperForm();
        $helper->show_toolbar = false;
        $helper->table = $this->table;
        $helper->module = $this;
        $helper->default_form_language = $this->context->language->id;
        $helper->allow_employee_form_lang = Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG', 0);
        $helper->identifier = $this->identifier;
        $helper->submit_action = 'submitProductCustomizer';
        $helper->currentIndex = $this->context->link->getAdminLink('AdminModules', false) . '&configure=' . $this->name . '&tab_module=' . $this->tab . '&module_name=' . $this->name;
        $helper->token = Tools::getAdminTokenLite('AdminModules');

        // incarca valorile existente
        $helper->fields_value['PRODUCTCUSTOMIZER_PRICE'] = Configuration::get('PRODUCTCUSTOMIZER_PRICE');
        $helper->fields_value['PRODUCTCUSTOMIZER_DISCOUNT'] = Configuration::get('PRODUCTCUSTOMIZER_DISCOUNT');

        return $helper->generateForm([$fields_form]);
    }


    public function checkAndFixFees($cart)
    {
        if (self::$is_saving || !Validate::isLoadedObject($cart)) {
            return;
        }

        if ((int)Order::getOrderByCartId((int)$cart->id) > 0) {
            return;
        }

        self::$is_saving = true;

        try {
            $fee_product_id = (int)Configuration::get('PRODUCTCUSTOMIZER_ID_PRODUCT');

            // luam ID-urile produselor din cos 
            $cart_products = $cart->getProducts();
            $cart_product_ids = [];
            foreach ($cart_products as $p) {
                if ((int)$p['id_product'] !== $fee_product_id) {
                    $cart_product_ids[] = (int)$p['id_product'];
                }
            }

            // numaram dedicatiile valide (excludem blind date)
            $db_dedications = Db::getInstance()->executeS(
                'SELECT id_product FROM `' . _DB_PREFIX_ . 'product_customizer_dedication` 
                 WHERE id_cart = ' . (int)$cart->id . ' 
                 AND dedication_type != "blind_date"'
            );



            $valid_count = 0;
            if (!empty($db_dedications)) {
                foreach ($db_dedications as $d) {
                    // daca produsul dedicatiei este in cos -> VALID
                    if (in_array((int)$d['id_product'], $cart_product_ids)) {
                        $valid_count++;
                    }
                }
            }

            // calculam pretul (valorile din configure sau fallback)
            $target_price = 0;
            if ($valid_count > 0) {
                $std_price = (float)Configuration::get('PRODUCTCUSTOMIZER_PRICE');
                if ($std_price <= 0) $std_price = 5.00; // Fallback

                $disc_price = (float)Configuration::get('PRODUCTCUSTOMIZER_DISCOUNT');
                if ($disc_price <= 0) $disc_price = 3.50; // Fallback

                $target_price = $std_price + (($valid_count - 1) * $disc_price);
            }

            // DEBUG: Scrie în log-uri (Advanced Parameters -> Logs)
            PrestaShopLogger::addLog("ProductCustomizer: Cart ID {$cart->id}, Count {$valid_count}, Price {$target_price}", 1);

            // aplicam pretul
            $has_fee = $cart->containsProduct($fee_product_id);

            if ($target_price > 0) {
                if (!$has_fee) {
                    $cart->updateQty(1, $fee_product_id, null, false, 'up');
                }

                // cautam pretul specific existent
                $specific_price_id = (int)Db::getInstance()->getValue(
                    'SELECT `id_specific_price` FROM `' . _DB_PREFIX_ . 'specific_price` 
                     WHERE `id_cart`=' . (int)$cart->id . ' AND `id_product`=' . (int)$fee_product_id
                );

                if ($specific_price_id) {
                    $sp = new SpecificPrice($specific_price_id);
                    $sp->price = (float)$target_price;
                    $sp->update();
                } else {
                    $sp = new SpecificPrice();
                    $sp->id_cart = (int)$cart->id;
                    $sp->id_product = (int)$fee_product_id;
                    $sp->id_shop = 0;
                    $sp->id_shop_group = 0;
                    $sp->id_currency = 0;
                    $sp->id_country = 0;
                    $sp->id_group = 0;
                    $sp->id_customer = 0;
                    $sp->price = (float)$target_price;
                    $sp->from_quantity = 1;
                    $sp->reduction = 0;
                    $sp->reduction_type = 'amount';
                    $sp->from = '0000-00-00 00:00:00';
                    $sp->to = '0000-00-00 00:00:00';
                    $sp->add();
                }
            } else {
                if ($has_fee) {
                    $cart->deleteProduct($fee_product_id);
                    SpecificPrice::deleteByIdCart($cart->id, $fee_product_id);
                }
            }
        } catch (Exception $e) {
            PrestaShopLogger::addLog("ProductCustomizer Error: " . $e->getMessage(), 3);
        }

        self::$is_saving = false;
    }

    // hook-ul apeleaza funcția checkAndFixFees
    public function hookActionCartSave($params)
    {
        if (isset($params['cart'])) {
            $this->checkAndFixFees($params['cart']);
        }
    }
}
