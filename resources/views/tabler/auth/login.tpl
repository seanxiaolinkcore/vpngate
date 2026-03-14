{include file='header.tpl'}

<script src="https://unpkg.com/@simplewebauthn/browser/dist/bundle/index.umd.min.js"></script>

<body class="d-flex flex-column min-vh-100">
<div class="auth-page">
    <div class="container d-flex flex-column justify-content-center align-items-center flex-grow-1 py-5">
        <div class="w-100" style="max-width: 420px;">
            <div class="text-center mb-4">
                <a href="/" class="d-inline-flex align-items-center gap-2 text-decoration-none">
                    <img src="/images/uim-logo-round_96x96.png" height="48" alt="{$config['appName']}">
                </a>
                <h2 class="mt-3 mb-1 fw-700" style="font-size:1.5rem; letter-spacing:-0.02em;">{$t.auth.login_title}</h2>
                <p class="text-secondary mb-0" style="font-size:0.875rem;">{$config['appName']}</p>
            </div>

            <div class="card auth-card">
                <div class="card-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-500" style="font-size:0.875rem;">{$t.auth.email}</label>
                        <input id="email" type="email" class="form-control" placeholder="you@example.com" autocomplete="email">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-500 d-flex justify-content-between" style="font-size:0.875rem;">
                            {$t.auth.password}
                            <a href="/password/reset" class="text-secondary" style="font-weight:400;">{$t.auth.forgot_password}</a>
                        </label>
                        <div class="input-group">
                            <input id="password" type="password" class="form-control" autocomplete="current-password">
                            <button type="button" class="btn btn-outline-secondary" onclick="togglePasswordVisibility()" tabindex="-1" style="border-radius:0 8px 8px 0;">
                                <i class="ti ti-eye" id="pwd-eye"></i>
                            </button>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-check">
                            <input id="remember_me" type="checkbox" class="form-check-input"/>
                            <span class="form-check-label" style="font-size:0.875rem;">{$t.auth.remember_me}</span>
                        </label>
                    </div>
                    {if $public_setting['enable_login_captcha']}
                    <div class="mb-3">
                        {include file='captcha/div.tpl'}
                    </div>
                    {/if}
                    <div class="d-grid gap-2">
                        <button class="btn btn-primary"
                                hx-post="/auth/login" hx-swap="none" hx-vals='js:{
                                    {if $public_setting['enable_login_captcha']}
                                        {include file='captcha/ajax.tpl'}
                                    {/if}
                                    email: document.getElementById("email").value,
                                    password: document.getElementById("password").value,
                                    remember_me: document.getElementById("remember_me").checked,
                                 }'>
                            {$t.auth.login_btn}
                        </button>
                        <div class="text-center text-secondary" style="font-size:0.8rem;">— or —</div>
                        <button class="btn btn-outline-secondary" id="webauthnLogin">
                            <i class="ti ti-fingerprint me-1"></i>{$t.auth.webauthn_btn}
                        </button>
                    </div>
                </div>
            </div>

            <div class="text-center mt-3 text-secondary" style="font-size:0.875rem;">
                {$t.auth.no_account} <a href="/auth/register" class="fw-500">{$t.auth.register_link}</a>
            </div>

            <div class="text-center mt-3">
                {foreach $locale_list as $loc}
                <a href="/user/locale/{$loc}" class="text-secondary me-2" style="font-size:0.8rem; text-decoration:none;">
                    {if $loc === 'en_US'}EN{elseif $loc === 'zh_CN'}中文{elseif $loc === 'zh_TW'}繁中{elseif $loc === 'ja_JP'}日本語{else}{$loc}{/if}
                </a>
                {/foreach}
            </div>
        </div>
    </div>
</div>

<script>
    function togglePasswordVisibility() {
        var pwd = document.getElementById('password');
        var eye = document.getElementById('pwd-eye');
        if (pwd.type === 'password') {
            pwd.type = 'text';
            eye.className = 'ti ti-eye-off';
        } else {
            pwd.type = 'password';
            eye.className = 'ti ti-eye';
        }
    }
</script>

{if $public_setting['enable_login_captcha']}
    {include file='captcha/js.tpl'}
{/if}

{include file='footer.tpl'}

{literal}
    <script>
        const { startAuthentication } = SimpleWebAuthnBrowser;
        document.getElementById('webauthnLogin').addEventListener('click', async () => {
            const resp = await fetch('/auth/webauthn');
            const options = await resp.json();
            let asseResp;
            try {
                asseResp = await startAuthentication({ optionsJSON: options });
            } catch (error) {
                document.getElementById("fail-message").innerHTML = error;
                throw error;
            }
            const verificationResp = await fetch('/auth/webauthn', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(asseResp),
            });
            const verificationJSON = await verificationResp.json();
            if (verificationJSON.ret === 1) {
                document.getElementById("success-message").innerHTML = verificationJSON.msg;
                successDialog.show();
                window.location.href = verificationJSON.redir;
            } else {
                document.getElementById("fail-message").innerHTML = verificationJSON.msg;
                failDialog.show();
            }
        });
    </script>
{/literal}
