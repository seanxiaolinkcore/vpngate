<!doctype html>
<html lang="{$t.lang_code}" data-bs-theme="auto">

<head>
    <meta charset="utf-8"/>
    <meta name="robots" content="noindex">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"/>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <title>{$config['appName']}</title>
    <script>
        ;(function () {
            var htmlElement = document.querySelector("html");
            var theme = htmlElement.getAttribute("data-bs-theme");
            if (theme === 'dark-auto' || theme === 'auto') {
                function updateTheme() {
                    htmlElement.setAttribute("data-bs-theme",
                        window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light");
                }
                window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', updateTheme);
                updateTheme();
            }
        })()
    </script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="//{$config['jsdelivr_url']}/npm/@tabler/core@latest/dist/css/tabler.min.css" rel="stylesheet"/>
    <link href="//{$config['jsdelivr_url']}/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet"/>
    <script src="/assets/js/fuck.min.js"></script>
    <script src="//{$config['jsdelivr_url']}/npm/htmx.org@v2/dist/htmx.min.js"></script>
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
        }
        .auth-page {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: var(--tblr-bg-surface);
        }
        .auth-card {
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
        }
        [data-bs-theme="dark"] .auth-card {
            box-shadow: 0 4px 24px rgba(0,0,0,0.3);
        }
        .btn { font-weight: 500; }
        .form-control, .form-select {
            border-radius: 8px;
        }
        .form-control:focus {
            box-shadow: 0 0 0 3px rgba(59,130,246,0.15);
        }
    </style>
</head>

