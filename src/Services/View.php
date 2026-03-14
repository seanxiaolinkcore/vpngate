<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Config;
use Illuminate\Database\DatabaseManager;
use Smarty\Smarty;
use Twig\Environment;
use Twig\Loader\FilesystemLoader;
use const BASE_PATH;

final class View
{
    public static DatabaseManager $connection;
    public static float $beginTime;

    public static function getSmarty(): Smarty
    {
        $smarty = new Smarty();
        $user = Auth::getUser();

        $smarty->setTemplateDir(BASE_PATH . '/resources/views/' . self::getTheme($user) . '/');
        $smarty->setCompileDir(BASE_PATH . '/storage/framework/smarty/compile/');
        $smarty->setCacheDir(BASE_PATH . '/storage/framework/smarty/cache/');
        $smarty->assign('config', self::getConfig());
        $smarty->assign('public_setting', Config::getPublicConfig());
        $smarty->assign('user', $user);
        $smarty->assign('t', self::getTranslations($user));
        $smarty->assign('locale_list', I18n::getLocaleList());

        return $smarty;
    }

    public static function getTwig(): Environment
    {
        $user = Auth::getUser();
        $loader = new FilesystemLoader(BASE_PATH . '/resources/views/' . self::getTheme($user) . '/');

        $twig = new Environment($loader, [
            'cache' => BASE_PATH . '/storage/framework/twig/cache/',
        ]);

        $twig->addGlobal('config', self::getConfig());
        $twig->addGlobal('public_setting', Config::getPublicConfig());
        $twig->addGlobal('user', $user);
        $twig->addGlobal('t', self::getTranslations($user));
        $twig->addGlobal('locale_list', I18n::getLocaleList());

        return $twig;
    }

    public static function getTranslations($user): array
    {
        $lang = $user->isLogin && $user->locale ? $user->locale : ($_ENV['locale'] ?? 'en_US');
        $localeFile = BASE_PATH . '/resources/locale/' . $lang . '.php';
        if (! file_exists($localeFile)) {
            $lang = 'en_US';
            $localeFile = BASE_PATH . '/resources/locale/en_US.php';
        }
        return require $localeFile;
    }

    public static function getTheme($user): string
    {
        if ($user->isLogin) {
            $theme = $user->theme;
        } else {
            $theme = $_ENV['theme'];
        }

        return $theme;
    }

    public static function getConfig(): array
    {
        return [
            'appName' => $_ENV['appName'],
            'baseUrl' => $_ENV['baseUrl'],
            'jump_delay' => $_ENV['jump_delay'],
            'enable_kill' => $_ENV['enable_kill'],
            'enable_change_email' => $_ENV['enable_change_email'],
            'enable_r2_client_download' => $_ENV['enable_r2_client_download'],
            'jsdelivr_url' => $_ENV['jsdelivr_url'],
            'enable_telemetry' => $_ENV['enable_telemetry'] ?? true,
            // site default language
            'locale' => $_ENV['locale'],
        ];
    }
}
