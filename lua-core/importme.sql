-- IMPORT THIS TO YOUR DATABASE

CREATE TABLE `players` (
  `name` varchar(100) DEFAULT NULL,
  `license` varchar(100) NOT NULL,
  `cash` int(10) DEFAULT 0,
  `bank` int(10) DEFAULT 0,
  `ip` varchar(100) DEFAULT NULL,
  `playtime` bigint(20) unsigned DEFAULT 0,
  `lastConnection` varchar(100) DEFAULT NULL,
  `discordIdentifier` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;