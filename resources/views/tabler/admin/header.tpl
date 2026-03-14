<!doctype html>
<html lang="{$t.lang_code}">

<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"/>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport"/>
    <meta name="format-detection" content="telephone=no"/>
    <title>{$config['appName']}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="//{$config['jsdelivr_url']}/npm/@tabler/core@latest/dist/css/tabler.min.css" rel="stylesheet"/>
    <link href="//{$config['jsdelivr_url']}/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet"/>
    <script src="//{$config['jsdelivr_url']}/npm/qrcode_js@latest/qrcode.min.js"></script>
    <script src="//{$config['jsdelivr_url']}/npm/clipboard@latest/dist/clipboard.min.js"></script>
    <script src="//{$config['jsdelivr_url']}/npm/jquery/dist/jquery.min.js"></script>
    <script src="//{$config['jsdelivr_url']}/npm/htmx.org@latest/dist/htmx.min.js"></script>
    <style>
        :root {
            --panel-font: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            --navbar-bg: #1a1a2e;
            --navbar-border: rgba(255,255,255,0.06);
            --nav-hover: rgba(255,255,255,0.08);
            --nav-active: rgba(248,180,0,0.15);
        }
        body { font-family: var(--panel-font); }
        .navbar-panel {
            background: var(--navbar-bg);
            border-bottom: 1px solid var(--navbar-border);
            padding: 0;
            position: sticky;
            top: 0;
            z-index: 1030;
        }
        .navbar-panel .container-xl {
            display: flex;
            align-items: center;
            height: 60px;
        }
        .brand-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            padding: 0 1rem 0 0;
            flex-shrink: 0;
        }
        .brand-logo img { height: 30px; width: 30px; border-radius: 6px; }
        .brand-name {
            color: #f1f5f9;
            font-weight: 600;
            font-size: 0.95rem;
            white-space: nowrap;
        }
        .admin-badge {
            background: rgba(248,180,0,0.15);
            color: #f8b400;
            font-size: 0.65rem;
            font-weight: 600;
            padding: 2px 6px;
            border-radius: 4px;
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }
        .nav-divider {
            width: 1px;
            height: 24px;
            background: var(--navbar-border);
            margin: 0 0.75rem;
            flex-shrink: 0;
        }
        .nav-main {
            display: flex;
            align-items: center;
            flex: 1;
            gap: 0;
            list-style: none;
            margin: 0;
            padding: 0;
        }
        .nav-main > li > a,
        .nav-main > li > .nav-dropdown-toggle {
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 0 0.65rem;
            height: 60px;
            color: #94a3b8;
            font-size: 0.875rem;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            border: none;
            background: none;
            transition: color 0.15s, background 0.15s;
            white-space: nowrap;
            position: relative;
        }
        .nav-main > li > a:hover,
        .nav-main > li > .nav-dropdown-toggle:hover {
            color: #f1f5f9;
            background: var(--nav-hover);
        }
        .nav-main > li.show > .nav-dropdown-toggle { color: #f8b400; }
        .nav-chevron {
            font-size: 0.7rem !important;
            opacity: 0.5 !important;
            transition: transform 0.2s;
        }
        .show > .nav-chevron { transform: rotate(180deg); }
        .nav-dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            background: #1e293b;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 10px;
            min-width: 180px;
            padding: 0.4rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.4);
            display: none;
            z-index: 1000;
        }
        .nav-dropdown-menu.show {
            display: block;
            animation: dropIn 0.15s ease;
        }
        @keyframes dropIn {
            from { opacity: 0; transform: translateY(-6px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .nav-dropdown-menu a {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 0.45rem 0.75rem;
            color: #94a3b8;
            font-size: 0.85rem;
            text-decoration: none;
            border-radius: 6px;
            transition: color 0.15s, background 0.15s;
        }
        .nav-dropdown-menu a:hover {
            color: #f1f5f9;
            background: rgba(255,255,255,0.07);
        }
        .nav-dropdown-menu a i {
            font-size: 0.95rem;
            width: 18px;
            color: #64748b;
            flex-shrink: 0;
        }
        .nav-dropdown-menu a:hover i { color: #f8b400; }
        .nav-dropdown-menu .sub-menu-toggle {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 0.45rem 0.75rem;
            color: #94a3b8;
            font-size: 0.85rem;
            cursor: pointer;
            border-radius: 6px;
            transition: color 0.15s, background 0.15s;
            border: none;
            background: none;
            width: 100%;
            text-align: left;
        }
        .nav-dropdown-menu .sub-menu-toggle:hover {
            color: #f1f5f9;
            background: rgba(255,255,255,0.07);
        }
        .nav-dropdown-menu .sub-menu-toggle i {
            font-size: 0.95rem;
            width: 18px;
            color: #64748b;
        }
        .nav-dropdown-menu .sub-menu-toggle .chevron {
            margin-left: auto;
            font-size: 0.7rem !important;
            opacity: 0.5;
            transition: transform 0.2s;
        }
        .sub-menu {
            padding: 0.2rem 0 0.2rem 1.5rem;
            display: none;
        }
        .sub-menu.open { display: block; }
        .sub-menu a { font-size: 0.82rem; }
        .nav-right {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            margin-left: auto;
            flex-shrink: 0;
        }
        .user-menu-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 4px 10px 4px 4px;
            border-radius: 8px;
            color: #94a3b8;
            background: none;
            border: none;
            cursor: pointer;
            transition: color 0.15s, background 0.15s;
        }
        .user-menu-btn:hover {
            color: #f1f5f9;
            background: var(--nav-hover);
        }
        .user-avatar {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background-size: cover;
            background-position: center;
            flex-shrink: 0;
        }
        .user-dropdown-menu {
            position: absolute;
            top: calc(100% + 8px);
            right: 0;
            background: #1e293b;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 10px;
            min-width: 200px;
            padding: 0.4rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.4);
            display: none;
            z-index: 1000;
        }
        .user-dropdown-menu.show {
            display: block;
            animation: dropIn 0.15s ease;
        }
        .user-dropdown-menu a {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 0.45rem 0.75rem;
            color: #94a3b8;
            font-size: 0.85rem;
            text-decoration: none;
            border-radius: 6px;
            transition: color 0.15s, background 0.15s;
        }
        .user-dropdown-menu a:hover { color: #f1f5f9; background: rgba(255,255,255,0.07); }
        .user-dropdown-menu a i { font-size: 0.95rem; width: 18px; color: #64748b; }
        .user-dropdown-menu .divider { border-top: 1px solid rgba(255,255,255,0.06); margin: 0.3rem 0; }
        .mobile-toggle {
            display: none;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 8px;
            color: #94a3b8;
            background: none;
            border: none;
            cursor: pointer;
            margin-left: 0.5rem;
        }
        @media (max-width: 991px) {
            .mobile-toggle { display: flex; }
            .nav-main-wrap {
                position: fixed;
                top: 60px;
                left: 0;
                right: 0;
                background: #1a1a2e;
                border-bottom: 1px solid var(--navbar-border);
                padding: 0.5rem;
                display: none;
                max-height: calc(100vh - 60px);
                overflow-y: auto;
                z-index: 1029;
            }
            .nav-main-wrap.open { display: block; }
            .nav-main { flex-direction: column; align-items: stretch; }
            .nav-main > li > a,
            .nav-main > li > .nav-dropdown-toggle { height: 44px; padding: 0 1rem; border-radius: 8px; }
            .nav-dropdown-menu {
                position: static;
                background: rgba(255,255,255,0.03);
                border: none;
                border-radius: 8px;
                box-shadow: none;
                padding: 0.25rem 0 0.25rem 1rem;
                margin-top: 2px;
                display: none;
            }
            .nav-dropdown-menu.show { display: block; animation: none; }
            .nav-divider { display: none; }
        }
        .card { border-radius: 12px; }
        .btn { font-weight: 500; }
    </style>
</head>

{if $user->is_dark_mode}
<body data-bs-theme="dark">
{else}
<body>
{/if}
<div class="page">
    <nav class="navbar-panel">
        <div class="container-xl">
            <a href="/admin" class="brand-logo">
                <img src="/images/uim-logo-round_48x48.png" alt="{$config['appName']}">
                <span class="brand-name d-none d-sm-block">{$config['appName']}</span>
                <span class="admin-badge d-none d-sm-block">Admin</span>
            </a>

            <div class="nav-divider d-none d-lg-block"></div>

            <div class="nav-main-wrap" id="nav-main-wrap">
                <ul class="nav-main">
                    <li>
                        <a href="/admin">
                            <i class="ti ti-home"></i>
                            <span>{$t.admin_nav.overview}</span>
                        </a>
                    </li>
                    <li class="dropdown-parent">
                        <button type="button" class="nav-dropdown-toggle" onclick="toggleNavDrop(this)">
                            <i class="ti ti-settings"></i>
                            <span>{$t.admin_nav.manage}</span>
                            <i class="ti ti-chevron-down nav-chevron"></i>
                        </button>
                        <div class="nav-dropdown-menu">
                            <button type="button" class="sub-menu-toggle" onclick="toggleSubMenu(this)">
                                <i class="ti ti-adjustments"></i>
                                {$t.admin_nav.settings}
                                <i class="ti ti-chevron-right chevron"></i>
                            </button>
                            <div class="sub-menu">
                                <a href="/admin/setting/billing"><i class="ti ti-coin"></i>{$t.admin_nav.billing_settings}</a>
                                <a href="/admin/setting/email"><i class="ti ti-mail"></i>{$t.admin_nav.email_settings}</a>
                                <a href="/admin/setting/support"><i class="ti ti-headset"></i>{$t.admin_nav.support_settings}</a>
                                <a href="/admin/setting/captcha"><i class="ti ti-shield"></i>{$t.admin_nav.captcha_settings}</a>
                                <a href="/admin/setting/reg"><i class="ti ti-user-plus"></i>{$t.admin_nav.reg_settings}</a>
                                <a href="/admin/setting/ref"><i class="ti ti-friends"></i>{$t.admin_nav.ref_settings}</a>
                                <a href="/admin/setting/im"><i class="ti ti-brand-telegram"></i>{$t.admin_nav.im_settings}</a>
                                <a href="/admin/setting/sub"><i class="ti ti-rss"></i>{$t.admin_nav.sub_settings}</a>
                                <a href="/admin/setting/cron"><i class="ti ti-clock"></i>{$t.admin_nav.cron_settings}</a>
                                <a href="/admin/setting/feature"><i class="ti ti-tool"></i>{$t.admin_nav.feature_settings}</a>
                            </div>
                            <a href="/admin/user"><i class="ti ti-users"></i>{$t.admin_nav.users}</a>
                            <a href="/admin/node"><i class="ti ti-server-2"></i>{$t.admin_nav.nodes}</a>
                            <a href="/admin/system"><i class="ti ti-tool"></i>{$t.admin_nav.system}</a>
                        </div>
                    </li>
                    <li class="dropdown-parent">
                        <button type="button" class="nav-dropdown-toggle" onclick="toggleNavDrop(this)">
                            <i class="ti ti-brand-hipchat"></i>
                            <span>{$t.admin_nav.operations}</span>
                            <i class="ti ti-chevron-down nav-chevron"></i>
                        </button>
                        <div class="nav-dropdown-menu">
                            <a href="/admin/announcement"><i class="ti ti-speakerphone"></i>{$t.admin_nav.announcements}</a>
                            <a href="/admin/ticket"><i class="ti ti-messages"></i>{$t.admin_nav.tickets}</a>
                            <a href="/admin/docs"><i class="ti ti-notes"></i>{$t.admin_nav.docs}</a>
                        </div>
                    </li>
                    <li class="dropdown-parent">
                        <button type="button" class="nav-dropdown-toggle" onclick="toggleNavDrop(this)">
                            <i class="ti ti-address-book"></i>
                            <span>{$t.admin_nav.logs}</span>
                            <i class="ti ti-chevron-down nav-chevron"></i>
                        </button>
                        <div class="nav-dropdown-menu">
                            <a href="/admin/login"><i class="ti ti-login"></i>{$t.admin_nav.login_log}</a>
                            <a href="/admin/subscribe"><i class="ti ti-rss"></i>{$t.admin_nav.subscribe_log}</a>
                            <a href="/admin/payback"><i class="ti ti-friends"></i>{$t.admin_nav.payback_log}</a>
                            <a href="/admin/money"><i class="ti ti-coin"></i>{$t.admin_nav.money_log}</a>
                            <a href="/admin/gateway"><i class="ti ti-torii"></i>{$t.admin_nav.gateway_log}</a>
                            <a href="/admin/online"><i class="ti ti-router"></i>{$t.admin_nav.online_log}</a>
                            <a href="/admin/syslog"><i class="ti ti-terminal"></i>{$t.admin_nav.syslog}</a>
                        </div>
                    </li>
                    <li class="dropdown-parent">
                        <button type="button" class="nav-dropdown-toggle" onclick="toggleNavDrop(this)">
                            <i class="ti ti-shield-check"></i>
                            <span>{$t.admin_nav.audit}</span>
                            <i class="ti ti-chevron-down nav-chevron"></i>
                        </button>
                        <div class="nav-dropdown-menu">
                            <a href="/admin/detect"><i class="ti ti-barrier-block"></i>{$t.admin_nav.rules}</a>
                            <a href="/admin/detect/log"><i class="ti ti-notes"></i>{$t.admin_nav.detect_log}</a>
                            <a href="/admin/detect/ban"><i class="ti ti-notes"></i>{$t.admin_nav.ban_log}</a>
                        </div>
                    </li>
                    <li class="dropdown-parent">
                        <button type="button" class="nav-dropdown-toggle" onclick="toggleNavDrop(this)">
                            <i class="ti ti-coin"></i>
                            <span>{$t.admin_nav.finance}</span>
                            <i class="ti ti-chevron-down nav-chevron"></i>
                        </button>
                        <div class="nav-dropdown-menu">
                            <a href="/admin/product"><i class="ti ti-list-details"></i>{$t.admin_nav.products}</a>
                            <a href="/admin/order"><i class="ti ti-receipt"></i>{$t.admin_nav.orders}</a>
                            <a href="/admin/invoice"><i class="ti ti-file-dollar"></i>{$t.admin_nav.invoices}</a>
                            <a href="/admin/coupon"><i class="ti ti-ticket"></i>{$t.admin_nav.coupons}</a>
                            <a href="/admin/giftcard"><i class="ti ti-gift"></i>{$t.admin_nav.gift_cards}</a>
                        </div>
                    </li>
                    <li>
                        <a href="/user">
                            <i class="ti ti-arrow-back-up"></i>
                            <span>{$t.admin_nav.back_to_user}</span>
                        </a>
                    </li>
                </ul>
            </div>

            <div class="nav-right">
                <div style="position:relative;">
                    <button class="user-menu-btn" onclick="toggleUserMenu()" id="user-menu-btn">
                        <div class="user-avatar" style="background-image: url({$user->dice_bear})"></div>
                        <i class="ti ti-chevron-down nav-chevron" style="font-size:0.7rem; opacity:0.5;"></i>
                    </button>
                    <div class="user-dropdown-menu" id="user-menu">
                        <a href="/user/logout"><i class="ti ti-logout"></i>{$t.nav.logout}</a>
                    </div>
                </div>
                <button class="mobile-toggle" onclick="toggleMobileNav()" id="mobile-toggle">
                    <i class="ti ti-menu-2" id="mobile-toggle-icon"></i>
                </button>
            </div>
        </div>
    </nav>

    <script>
    (function() {
        function closeAll() {
            document.querySelectorAll('.nav-dropdown-menu.show').forEach(function(el) { el.classList.remove('show'); });
            document.querySelectorAll('.dropdown-parent.show').forEach(function(el) { el.classList.remove('show'); });
            document.querySelectorAll('.user-dropdown-menu.show').forEach(function(el) { el.classList.remove('show'); });
        }
        window.toggleNavDrop = function(btn) {
            var parent = btn.closest('.dropdown-parent');
            var menu = parent.querySelector('.nav-dropdown-menu');
            var isOpen = menu.classList.contains('show');
            closeAll();
            if (!isOpen) { menu.classList.add('show'); parent.classList.add('show'); }
        };
        window.toggleSubMenu = function(btn) {
            var sub = btn.nextElementSibling;
            var chevron = btn.querySelector('.chevron');
            sub.classList.toggle('open');
            if (chevron) chevron.style.transform = sub.classList.contains('open') ? 'rotate(90deg)' : '';
        };
        window.toggleUserMenu = function() {
            var menu = document.getElementById('user-menu');
            var isOpen = menu.classList.contains('show');
            closeAll();
            if (!isOpen) menu.classList.add('show');
        };
        window.toggleMobileNav = function() {
            var wrap = document.getElementById('nav-main-wrap');
            var icon = document.getElementById('mobile-toggle-icon');
            wrap.classList.toggle('open');
            icon.className = wrap.classList.contains('open') ? 'ti ti-x' : 'ti ti-menu-2';
        };
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.dropdown-parent') && !e.target.closest('#user-menu-btn') && !e.target.closest('#user-menu') && !e.target.closest('#mobile-toggle') && !e.target.closest('#nav-main-wrap')) {
                closeAll();
                var wrap = document.getElementById('nav-main-wrap');
                if (wrap) wrap.classList.remove('open');
            }
        });
    })();
    </script>
