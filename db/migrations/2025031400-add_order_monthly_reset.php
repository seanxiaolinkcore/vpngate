<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        DB::getPdo()->exec("
            ALTER TABLE `order`
                ADD COLUMN IF NOT EXISTS `next_reset_time` int(11) unsigned NOT NULL DEFAULT 0
                    COMMENT '下次月流量重置时间（Unix 时间戳，0 表示不启用月重置）';
            ALTER TABLE `order`
                ADD COLUMN IF NOT EXISTS `monthly_bandwidth` double unsigned NOT NULL DEFAULT 0
                    COMMENT '每月重置流量（GB，0 表示不启用月重置）';
        ");

        return 2025031400;
    }

    public function down(): int
    {
        DB::getPdo()->exec('
            ALTER TABLE `order` DROP COLUMN IF EXISTS `next_reset_time`;
            ALTER TABLE `order` DROP COLUMN IF EXISTS `monthly_bandwidth`;
        ');

        return 2024061600;
    }
};
