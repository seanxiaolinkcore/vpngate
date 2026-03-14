<!doctype html>
<html lang="{$t.lang_code}">

<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"/>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <meta name="referrer" content="never">
    <title>{$config['appName']}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="//{$config['jsdelivr_url']}/npm/@tabler/core@latest/dist/css/tabler.min.css" rel="stylesheet"/>
    <link href="//{$config['jsdelivr_url']}/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet"/>
    <script src="/assets/js/fuck.min.js"></script>
    <script src="//{$config['jsdelivr_url']}/npm/qrcode_js@latest/qrcode.min.js"></script>
    <script src="//{$config['jsdelivr_url']}/npm/clipboard@latest/dist/clipboard.min.js"></script>
    <script src="//{$config['jsdelivr_url']}/npm/htmx.org@latest/dist/htmx.min.js"></script>
    <style>
        :root {
            --panel-font: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            --navbar-bg: #0f172a;
            --navbar-border: rgba(255,255,255,0.06);
            --nav-hover: rgba(255,255,255,0.08);
            --nav-active: rgba(99,179,237,0.15);
        }

        body {
            font-family: var(--panel-font);
        }

        .navbar-panel {
            background: var(--navbar-bg);
            border-bottom: 1px solid var(--navbar-border);
            padding: 0;
            position: sticky;
            top: 0;
            z-index: 1030;
            backdrop-filter: blur(12px);
        }

        .navbar-panel .container-xl {
            display: flex;
            align-items: center;
            height: 60px;
            gap: 0;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            padding: 0 1rem 0 0;
            flex-shrink: 0;
        }

        .brand-logo img {
            height: 30px;
            width: 30px;
            border-radius: 6px;
        }

        .brand-name {
            color: #f1f5f9;
            font-weight: 600;
            font-size: 0.95rem;
            letter-spacing: -0.01em;
            white-space: nowrap;
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

        .nav-main > li > a.active,
        .nav-main > li.show > .nav-dropdown-toggle {
            color: #63b3ed;
            background: var(--nav-active);
        }

        .nav-main > li > a i,
        .nav-main > li > .nav-dropdown-toggle i {
            font-size: 1rem;
            opacity: 0.8;
        }

        .nav-chevron {
            font-size: 0.7rem !important;
            opacity: 0.5 !important;
            transition: transform 0.2s;
        }

        .show > .nav-chevron {
            transform: rotate(180deg);
        }

        .nav-dropdown-menu {
            position: absolute;
            top: calc(100% + 0px);
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

        .nav-dropdown-menu a:hover i {
            color: #63b3ed;
        }

        .nav-dropdown-menu .menu-section {
            padding: 0.25rem 0.75rem 0.1rem;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: #475569;
            margin-top: 0.25rem;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            margin-left: auto;
            flex-shrink: 0;
        }

        .nav-icon-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 8px;
            color: #94a3b8;
            background: none;
            border: none;
            cursor: pointer;
            transition: color 0.15s, background 0.15s;
            text-decoration: none;
        }

        .nav-icon-btn:hover {
            color: #f1f5f9;
            background: var(--nav-hover);
        }

        .nav-icon-btn i {
            font-size: 1.1rem;
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

        .user-info {
            display: none;
        }

        @media (min-width: 1200px) {
            .user-info {
                display: block;
                text-align: left;
            }
            .user-info .user-email {
                font-size: 0.82rem;
                font-weight: 500;
                color: #e2e8f0;
                line-height: 1.2;
            }
            .user-info .user-name {
                font-size: 0.72rem;
                color: #64748b;
                line-height: 1.2;
            }
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

        .user-dropdown-menu .user-header {
            padding: 0.5rem 0.75rem 0.6rem;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            margin-bottom: 0.3rem;
        }

        .user-dropdown-menu .user-header .email {
            font-size: 0.82rem;
            font-weight: 500;
            color: #e2e8f0;
        }

        .user-dropdown-menu .user-header .name {
            font-size: 0.72rem;
            color: #64748b;
        }

        .user-dropdown-menu a,
        .user-dropdown-menu button {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 0.45rem 0.75rem;
            color: #94a3b8;
            font-size: 0.85rem;
            text-decoration: none;
            border-radius: 6px;
            transition: color 0.15s, background 0.15s;
            width: 100%;
            border: none;
            background: none;
            cursor: pointer;
            text-align: left;
        }

        .user-dropdown-menu a:hover,
        .user-dropdown-menu button:hover {
            color: #f1f5f9;
            background: rgba(255,255,255,0.07);
        }

        .user-dropdown-menu a i,
        .user-dropdown-menu button i {
            font-size: 0.95rem;
            width: 18px;
            color: #64748b;
            flex-shrink: 0;
        }

        .user-dropdown-menu a:hover i,
        .user-dropdown-menu button:hover i {
            color: #63b3ed;
        }

        .user-dropdown-menu .divider {
            border-top: 1px solid rgba(255,255,255,0.06);
            margin: 0.3rem 0;
        }

        .user-dropdown-menu .logout-btn {
            color: #f87171 !important;
        }

        .user-dropdown-menu .logout-btn i {
            color: #f87171 !important;
        }

        .lang-menu {
            position: absolute;
            top: calc(100% + 8px);
            right: 0;
            background: #1e293b;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 10px;
            min-width: 160px;
            padding: 0.4rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.4);
            display: none;
            z-index: 1000;
        }

        .lang-menu.show {
            display: block;
            animation: dropIn 0.15s ease;
        }

        .lang-menu a {
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

        .lang-menu a:hover,
        .lang-menu a.active-lang {
            color: #f1f5f9;
            background: rgba(255,255,255,0.07);
        }

        .lang-menu a.active-lang {
            color: #63b3ed;
        }

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
            margin-left: auto;
        }

        .mobile-toggle:hover {
            color: #f1f5f9;
            background: var(--nav-hover);
        }

        @media (max-width: 991px) {
            .mobile-toggle {
                display: flex;
            }

            .nav-main-wrap {
                position: fixed;
                top: 60px;
                left: 0;
                right: 0;
                background: #0f172a;
                border-bottom: 1px solid var(--navbar-border);
                padding: 0.5rem;
                display: none;
                max-height: calc(100vh - 60px);
                overflow-y: auto;
                z-index: 1029;
            }

            .nav-main-wrap.open {
                display: block;
            }

            .nav-main {
                flex-direction: column;
                align-items: stretch;
            }

            .nav-main > li > a,
            .nav-main > li > .nav-dropdown-toggle {
                height: 44px;
                padding: 0 1rem;
                border-radius: 8px;
            }

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

            .nav-dropdown-menu.show {
                display: block;
                animation: none;
            }

            .nav-divider {
                display: none;
            }
        }

        .page {
            font-family: var(--panel-font);
        }

        .page-header {
            padding-top: 1.5rem;
            padding-bottom: 1.5rem;
        }

        .home-title {
            font-size: 1.75rem;
            font-weight: 700;
            letter-spacing: -0.02em;
        }

        .home-subtitle {
            font-size: 0.875rem;
            opacity: 0.75;
        }

        .card {
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04);
        }

        .btn {
            font-weight: 500;
        }

        [data-bs-theme="dark"] .card {
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
        }
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
            <a href="/user" class="brand-logo">
                <img src="/images/uim-logo-round_48x48.png" alt="{$config['appName']}">
                <span class="brand-name d-none d-sm-block">{$config['appName']}</span>
            </a>

            <div class="nav-divider d-none d-lg-block"></div>

            <div class="nav-main-wrap" id="nav-main-wrap">
                <ul class="nav-main">
                    <li>
                        <a href="/user">
                            <i class="ti ti-home"></i>
                            <span>{$t.nav.home}</span>
                        </a>
                    </li>
                    <li class="dropdown-parent">
                        <button type="button" class="nav-dropdown-toggle" onclick="toggleNavDrop(this)">
                            <i class="ti ti-user"></i>
                            <span>{$t.nav.my}</span>
                            <i class="ti ti-chevron-down nav-chevron"></i>
                        </button>
                        <div class="nav-dropdown-menu">
                            <a href="/user/profile"><i class="ti ti-info-square"></i>{$t.nav.account}</a>
                            <a href="/user/edit"><i class="ti ti-edit"></i>{$t.nav.profile}</a>
                            <a href="/user/invite"><i class="ti ti-friends"></i>{$t.nav.invite}</a>
                        </div>
                    </li>
                    <li class="dropdown-parent">
                        <button type="button" class="nav-dropdown-toggle" onclick="toggleNavDrop(this)">
                            <i class="ti ti-server"></i>
                            <span>{$t.nav.usage}</span>
                            <i class="ti ti-chevron-down nav-chevron"></i>
                        </button>
                        <div class="nav-dropdown-menu">
                            <a href="/user/server"><i class="ti ti-server-2"></i>{$t.nav.nodes}</a>
                            <a href="/user/rate"><i class="ti ti-chart-bar"></i>{$t.nav.traffic_rate}</a>
                        </div>
                    </li>
                    <li class="dropdown-parent">
                        <button type="button" class="nav-dropdown-toggle" onclick="toggleNavDrop(this)">
                            <i class="ti ti-headset"></i>
                            <span>{$t.nav.support}</span>
                            <i class="ti ti-chevron-down nav-chevron"></i>
                        </button>
                        <div class="nav-dropdown-menu">
                            <a href="/user/announcement"><i class="ti ti-speakerphone"></i>{$t.nav.announcements}</a>
                            {if $public_setting['enable_ticket']}
                            <a href="/user/ticket"><i class="ti ti-ticket"></i>{$t.nav.tickets}</a>
                            {/if}
                            {if $public_setting['display_docs'] && (! $public_setting['display_docs_only_for_paid_user'] || $user->class !== 0)}
                            <a href="/user/docs"><i class="ti ti-notes"></i>{$t.nav.docs}</a>
                            {/if}
                        </div>
                    </li>
                    <li class="dropdown-parent">
                        <button type="button" class="nav-dropdown-toggle" onclick="toggleNavDrop(this)">
                            <i class="ti ti-shield-check"></i>
                            <span>{$t.nav.audit}</span>
                            <i class="ti ti-chevron-down nav-chevron"></i>
                        </button>
                        <div class="nav-dropdown-menu">
                            <a href="/user/detect"><i class="ti ti-barrier-block"></i>{$t.nav.rules}</a>
                            {if $public_setting['display_detect_log']}
                            <a href="/user/detect/log"><i class="ti ti-notes"></i>{$t.nav.logs}</a>
                            {/if}
                        </div>
                    </li>
                    <li class="dropdown-parent">
                        <button type="button" class="nav-dropdown-toggle" onclick="toggleNavDrop(this)">
                            <i class="ti ti-building-store"></i>
                            <span>{$t.nav.shop}</span>
                            <i class="ti ti-chevron-down nav-chevron"></i>
                        </button>
                        <div class="nav-dropdown-menu">
                            <a href="/user/product"><i class="ti ti-list"></i>{$t.nav.products}</a>
                            <a href="/user/order"><i class="ti ti-file-invoice"></i>{$t.nav.orders}</a>
                            <a href="/user/invoice"><i class="ti ti-file-dollar"></i>{$t.nav.invoices}</a>
                            <a href="/user/money"><i class="ti ti-home-dollar"></i>{$t.nav.balance}</a>
                        </div>
                    </li>
                    {if $user->is_admin}
                    <li>
                        <a href="/admin">
                            <i class="ti ti-settings"></i>
                            <span>{$t.nav.admin_panel}</span>
                        </a>
                    </li>
                    {/if}
                </ul>
            </div>

            <div class="nav-right">
                <div style="position:relative;">
                    <button class="nav-icon-btn" onclick="toggleLangMenu()" title="{$t.nav.language}" id="lang-btn">
                        <i class="ti ti-language"></i>
                    </button>
                    <div class="lang-menu" id="lang-menu">
                        {foreach $locale_list as $loc}
                        <a href="/user/locale/{$loc}" class="{if $user->locale === $loc}active-lang{/if}">
                            {if $loc === 'en_US'}English
                            {elseif $loc === 'zh_CN'}中文
                            {elseif $loc === 'zh_TW'}正體中文
                            {elseif $loc === 'ja_JP'}日本語
                            {else}{$loc}
                            {/if}
                        </a>
                        {/foreach}
                    </div>
                </div>

                <div style="position:relative;">
                    <button class="user-menu-btn" onclick="toggleUserMenu()" id="user-menu-btn">
                        <div class="user-avatar" style="background-image: url({$user->dice_bear})"></div>
                        <div class="user-info">
                            <div class="user-email">{$user->email}</div>
                            <div class="user-name">{$user->user_name}</div>
                        </div>
                        <i class="ti ti-chevron-down nav-chevron" style="font-size:0.7rem; opacity:0.5;"></i>
                    </button>
                    <div class="user-dropdown-menu" id="user-menu">
                        <div class="user-header">
                            <div class="email">{$user->email}</div>
                            <div class="name">{$user->user_name}</div>
                        </div>
                        {if $user->is_dark_mode}
                        <button hx-post="/user/switch_theme_mode" hx-swap="none">
                            <i class="ti ti-sun"></i>{$t.nav.light_mode}
                        </button>
                        {else}
                        <button hx-post="/user/switch_theme_mode" hx-swap="none">
                            <i class="ti ti-moon"></i>{$t.nav.dark_mode}
                        </button>
                        {/if}
                        <div class="divider"></div>
                        <a href="/user/logout" class="logout-btn">
                            <i class="ti ti-logout"></i>{$t.nav.logout}
                        </a>
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
            document.querySelectorAll('.nav-dropdown-menu.show, .lang-menu.show, .user-dropdown-menu.show').forEach(function(el) {
                el.classList.remove('show');
            });
            document.querySelectorAll('.dropdown-parent.show').forEach(function(el) {
                el.classList.remove('show');
            });
        }

        window.toggleNavDrop = function(btn) {
            var parent = btn.closest('.dropdown-parent');
            var menu = parent.querySelector('.nav-dropdown-menu');
            var isOpen = menu.classList.contains('show');
            closeAll();
            if (!isOpen) {
                menu.classList.add('show');
                parent.classList.add('show');
            }
        };

        window.toggleLangMenu = function() {
            var menu = document.getElementById('lang-menu');
            var userMenu = document.getElementById('user-menu');
            var isOpen = menu.classList.contains('show');
            closeAll();
            if (!isOpen) menu.classList.add('show');
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
            if (!e.target.closest('.dropdown-parent') &&
                !e.target.closest('#lang-btn') &&
                !e.target.closest('#lang-menu') &&
                !e.target.closest('#user-menu-btn') &&
                !e.target.closest('#user-menu') &&
                !e.target.closest('#mobile-toggle') &&
                !e.target.closest('#nav-main-wrap')) {
                closeAll();
                var wrap = document.getElementById('nav-main-wrap');
                if (wrap) {
                    wrap.classList.remove('open');
                    var icon = document.getElementById('mobile-toggle-icon');
                    if (icon) icon.className = 'ti ti-menu-2';
                }
            }
        });
    })();
    </script>
