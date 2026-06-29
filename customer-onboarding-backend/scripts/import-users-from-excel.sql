-- Generated 2026-04-24 15:32:50
-- Source workbook: D:\Project Office\TelebirrAgent\Users.xlsx
-- Default password applied to imported users: Gbe@1234
BEGIN;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('101', 'Beklobet Branch', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('102', 'SARIS BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('103', 'SIDAMO-TERA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('104', 'DUBAI-TERA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('105', 'SHIROMEDA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('106', 'MESALEMIA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('107', 'DURAME BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('108', 'KALITY BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('109', 'Stadium Branch', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('111', 'JEMO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('112', 'SUMMIT BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('113', 'GOFA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('114', 'BETHEL BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('116', 'KALITY GEBRIEL BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('119', 'TEKLEHAIMANOT BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('120', 'BOLE MICHAEL BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('121', 'ATIKILT-TERA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('122', 'BOLE MEDEHANIALEM BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('123', 'NIFAS SILK BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('124', 'LIDETA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('126', 'KOLFE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('127', 'LEBU BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('128', 'ADDISU GEBEYA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('129', 'WESSEN BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('130', 'AYAT BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('131', 'GULELE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('132', 'AUTOBUS-TERA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('133', 'ADEY ABEBA STADIUM', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('134', 'LAFTO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('135', 'KAZANCHIS BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('136', 'MEGENAGNA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('137', 'MEKANISA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('138', 'MILITARY-TERA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('139', 'BOLE BULBULA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('141', 'HANA-MARIAM BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('142', 'ALEM-BANK BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('143', 'FRASH-TERA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('144', 'CMC-MICHAEL BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('145', 'KERA SARBET BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('146', 'BISRATE GEBREAL BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('147', 'GOTERA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('148', 'KEBENA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('149', 'AYERTENA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('151', 'LAMBERET', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('152', 'ARAT KILO', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('153', 'JAKROS BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('154', 'AKAKI BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('155', 'BOLE', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('156', 'CHURCHILL BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('157', 'DEJACH WUBE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('159', 'KOTEBE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('160', 'FERENSAY BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('161', 'TULUDIMTU BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('162', 'CMC BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('164', 'GELAN CONDOMINIUM BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('165', 'GORO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('166', 'GURD SHOLLA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('167', 'YOHANNES BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('168', 'WUHALIMAT BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('169', 'MEHAL GURD SHOLLA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('171', 'OLYMPIA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('172', 'KIRKOS BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('173', 'WELLO SEFER BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('174', 'AMIST KILLO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('175', 'SHOLLA GEBEYA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('176', 'BULBULA MEDHANIALEM BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('177', 'MEGENAGNA 24 BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('178', 'AYAT TSEBEL BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('179', 'AYAT 49 BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('180', 'YEKA ABADO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('181', 'TAFO ADEBABAY BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('182', 'GERJI LEMLEM BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('183', 'KOTEBE COLLEGE', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('184', 'FIGA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('185', 'Bole - Dildiy', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('186', 'KARA ALO', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('187', 'DEMBEL', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('188', 'AYAT TAFO', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('189', 'SUMMIT72', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('190', 'MEXICO PREMIUM', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('191', 'LEBU MEBRAT', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('192', 'WUHALIMAT DILDIY', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('193', 'BETHEL ALEMBANK', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('195', 'TULU DIMTU ADEBABAY', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('196', 'GORO GEBRIEL', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('197', 'AKAKI TOTAL', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('199', 'BULGARIA MAZORIA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('200', 'MERI LOKE', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('201', 'HAWASSA  BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('202', 'HOSSAENA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('203', 'YIRGACHEFE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('204', 'WOLAYITA-SODO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('205', 'DILLA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('207', 'WORABE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('209', 'SHASHEMENE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('211', 'ALETAWONDO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('212', 'YIRGALEM BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('213', 'ARBA MINCH BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('214', 'TABOR  BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('215', 'BUTAJIRA  BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('216', 'BISHOFTU BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('217', 'MENEHARIA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('218', 'FURI BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('219', 'HAWASSA ADDISU GEBAYA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('220', 'HAWASSA MENAHERYA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('221', 'MODJO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('223', 'TARCHA  BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('224', 'BONGA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('225', 'METU BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('226', 'HALABA KULITO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('227', 'NARAMO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('228', 'HOSSAENA ARADA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('229', 'SHINSHICHO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('230', 'BULE HORA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('234', 'NEGELE ARSI', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('302', 'DEMBELA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('303', 'DIRE DAWA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('307', 'BOSET BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('308', 'DEDECHA ARARA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('309', 'BATU BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('311', 'SEMERA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('312', 'SEBETA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('313', 'BALE ROBE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('314', 'ASSELA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('315', 'ADAMA MEBRAT HAYIL BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('321', 'HASASA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('322', 'Adama Dipo', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('324', 'Adama Sole', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('325', 'ADAMA PAN AFRIC', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('327', 'ADAMA SAR TERA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('328', 'ADAMA SEKEKELO', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('329', 'ADAMA PICKOK', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('330', 'LUGO', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('335', 'TATEK INDUSTRY ZONE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('401', 'WOLKITE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('402', 'ALEMGENA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('403', 'JIMMA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('404', 'BURAYU BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('406', 'MIZAN BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('407', 'WOLLETE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('408', 'ASHEWA MEDA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('409', 'GAMBELLA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('410', 'AGARO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('411', 'AMBO BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('412', 'KETTA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('413', 'GEFERSA GUJE', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('414', 'ANFO ALPHA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('415', 'KELECHA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('416', 'ASSOSA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('501', 'MEKELE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('502', 'GONDER BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('503', 'BAHIR DAR BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('504', 'ADI HAKI BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('505', 'HUMERA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('506', 'DEBREBIRHAN BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('508', 'FICHE BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('509', 'MARAKI BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('510', 'GISH ABAY BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('511', 'SULULTA BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('513', 'SHIRE', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('514', 'ADIGRAT', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('515', 'ADIHA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('516', 'AXUM', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('600', '24 STADIUM', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('604', 'Africa Hibret', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('605', 'BULBULA 93 MAZORIA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('606', 'SEBATEGNA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('608', 'LEMIKURA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('611', 'CHID TERA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('612', 'LAFTO VIEW', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('613', 'SUMMIT GIORGIS', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('614', 'BULBULA CONDOMINIUM', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('616', 'GERJI MARIAM', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('617', 'AYAT 5', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('618', 'MEHAL LAFTO', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('619', 'Wechecha Branch', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('620', 'BOLE CARGO', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('621', 'GORO ADEBABAY BRANCH', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('622', 'AYAT ADDIS MENDER', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('623', 'SARIS ADDIS SEFER', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('625', 'AYAT 72', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('626', 'MEHAL SUMMIT', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('627', 'BULGARIA', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('629', 'MEHAL LAMBERET', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('631', 'LEM HOTEL', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('633', 'KILINTO', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('634', 'KALITY WUHALIMAT', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('635', 'BIHERAWE', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('636', 'SUMMIT MEDIHANEALEM', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('637', 'GERJI MEBRAT HAYIL', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Branches" ("BranchCode", "BranchName", "IsActive")
VALUES ('638', 'Garment Atikilit Tera', TRUE)
ON CONFLICT ("BranchCode") DO UPDATE
SET "BranchName" = EXCLUDED."BranchName", "IsActive" = TRUE;

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0476b435-ccbb-4d40-b729-34580c059009', '109_Maker01', 'Gojjam Abebay Hayal', '0938297421', '109', 'Stadium Branch', 'MAKER',
  decode('a12d6608affe785fef2b222b07a44fca783b6254aebcc1ebb693764084c20777', 'hex'), decode('d1c0dda4a3f43ecd94321dee22572e5a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '62ed3960-ccb6-4ad2-bd2a-2cdc653339fd', '109_Checker01', 'Firehiwot Hailemariam', '0921384173', '109', 'Stadium Branch', 'CHECKER',
  decode('4172dc2c0b39081dffe997acc86cc80d0c121b57156029075a74a712648429af', 'hex'), decode('33b06d2c4ab2d48d5d34b9f867fe03d1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '6fcf523c-6b7d-40fd-abf0-b8d0935310ac', '101_Maker01', 'Betelhem Tadele Gizaw', '0903764126', '101', 'Beklobet Branch', 'MAKER',
  decode('5897bddc5eee764363f56aa0b5d9860ab492b7e272436ba1431fa17b5ec6ee66', 'hex'), decode('38146eb6e7c48ff94600a3a4cdb7d992', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '7c4b1c4a-5da4-403b-962f-0a4d8a27cd52', '101_Checker01', 'Tizita Zeleke Ashenafi', '0913489147', '101', 'Beklobet Branch', 'CHECKER',
  decode('0b3f02a7f464952e0c42f36916725d33d565c6ccc395ecca1beacd8d0111558d', 'hex'), decode('92a14d6b633c388a275e640c62dc1860', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '875a8573-13dd-4db1-abe7-2127bf6c1adc', '102_Maker01', 'Markos Wolde', '0909489006', '102', 'SARIS BRANCH', 'MAKER',
  decode('066696a878ef52fef943eec4cee0000b7f98bf7413a1b61fdb3e6c316ccaa3b5', 'hex'), decode('05ffbbf50f3091f2589467b55c6ad8b1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'aec4a76e-42ed-4b20-a79c-175cda39062e', '102_Checker01', 'Betelehm Wondmu', '0929440322', '102', 'SARIS BRANCH', 'CHECKER',
  decode('4d5fba2207d423a62873b6715f1f26603519856218a6b0a916c163a96b06ac80', 'hex'), decode('e7c0b44bea1496963f052b611b85e77a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'bb1c83eb-9396-40fe-af17-dcb914941942', '103_Maker01', 'Amare Girum Mossisa', '0948261728', '103', 'SIDAMO-TERA BRANCH', 'MAKER',
  decode('aa03f4b5bdc8e668fc817e3aa1126b2bcc4b368d10938da08a044a5c575a78e2', 'hex'), decode('ce7d468daa8aa14a7cc5c6a2831acc54', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f87d6f27-5101-4326-8965-cf47a01c3acd', '103_Checker01', 'Tedi Asemera Tufa', '0947196898', '103', 'SIDAMO-TERA BRANCH', 'CHECKER',
  decode('d3e36bb77f763bb705564bb5db9f91cd3199665460a035be365027a6dafbc1b2', 'hex'), decode('83872e40d9b564a77463a5b99170f9ff', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'dff8e3e2-ecc0-4bc4-9acd-65781bf9fc0b', '104_Maker01', 'Balemlaye Abebew', '0978967325', '104', 'DUBAI-TERA BRANCH', 'MAKER',
  decode('4945801ca00528764a0605b2c329e357b9c5d8c970d065eacf27a72a8b4d2501', 'hex'), decode('ecf3b39ce0b9258287795ec913afa060', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1a243431-d954-431d-8d54-8cca8d4d5da7', '104_Checker01', 'Sisay Mlaiku Endalew', '0925466761', '104', 'DUBAI-TERA BRANCH', 'CHECKER',
  decode('557fcee0eb91a52a4331315da156189af1143373809731de5151bd94988421d1', 'hex'), decode('00eeadd94aeaa507c31e9338be1bc1d5', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '587f4806-d33c-4deb-93b6-06832038a39d', '105_Maker01', 'Zintalesh Asres Chaka', '0925730390', '105', 'SHIROMEDA BRANCH', 'MAKER',
  decode('5618f1c6438664053f9ae70dd34e26cde0fd893736579b57105bc01c9fddb8f1', 'hex'), decode('73778a6abffa2c0240e121f4b314c5fe', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '4ec14b58-705f-49bd-911e-157e783c2878', '105_Checker01', 'Bayu Desalegn Nigussie', '0934638514', '105', 'SHIROMEDA BRANCH', 'CHECKER',
  decode('befbb657d81fbc3deb3b8fe540e62e9d2f45348aa92cc550997a67c7b5649b9c', 'hex'), decode('7a39d5cedfee39af57c47e57943d6f70', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'cdd25046-ecd0-47c3-bf68-683815ea0dff', '106_Maker01', 'Meseret Kassa Balehu', '0919767880', '106', 'MESALEMIA BRANCH', 'MAKER',
  decode('4f1655afbd112b78b52f3af6004757304f8c4a50fe63906e7153a68ee3e9d1d6', 'hex'), decode('ef6625bfd01c206cb15674fe2ae83965', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3cac7ed5-47fe-472b-986c-12662a36b934', '106_Checker01', 'Ermias G/Michael', '0928744255', '106', 'MESALEMIA BRANCH', 'CHECKER',
  decode('62321cc563595eab90b7e03af88db45a827c4d06139e27a7beca6475aab7ce1c', 'hex'), decode('06116ef037a87bc2e08775d7485d824e', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5b60b1d8-5913-4ca7-bf9d-b4f9c96cacf3', '107_Maker01', 'Melaku Admasu Alkasu', '0920993531', '107', 'DURAME BRANCH', 'MAKER',
  decode('aebbd37a00ef2ab5a32262376af66f365c8592d21d7e6797349298b8149c8d27', 'hex'), decode('a5858f1e57d8c181871d6c20f97e3fdf', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '44bba266-cd66-486e-935e-418d65599848', '107_Checker01', 'Eshetu Tesfaye Anebo', '0925310198', '107', 'DURAME BRANCH', 'CHECKER',
  decode('c64fcf392ed712f11946344afb4b7ee73b5a22fa1f64f46f822a7303d57eac7e', 'hex'), decode('01c1bd40eb5cb5fd9f8fbc78e5b0aa70', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'bb9b4af3-9a15-4330-a488-dd3c5e934852', '108_Maker01', 'Melat B/meskel Gizzaw', '0924412885', '108', 'KALITY BRANCH', 'MAKER',
  decode('a2c4513f045f2bd45d4f59c08e9641389d5aa03abcb5b989a1ba1409acf5b353', 'hex'), decode('08f44b639864f1d338240e8a2658c34b', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5c0c719d-8633-4aa1-a583-3f28f19bb968', '108_Checker01', 'Teferi Erkalo Lubiso', '0912164637', '108', 'KALITY BRANCH', 'CHECKER',
  decode('903428a91808059621c8dd61ca28c45532addde01e0e3af8c870d716b56adbd1', 'hex'), decode('b5a97f2f3ec3eba128a29713baadd35b', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c9aacca4-7b63-408f-962e-8d69b70a10e7', '111_Maker01', 'Tilku Birhane Wube', '0920512568', '111', 'JEMO BRANCH', 'MAKER',
  decode('5188292cd0af3bb37bcfb87f8a82e57e919af9b4bc225489a0bbca6125e5ae9d', 'hex'), decode('1f3330791da9d37e28cc67dfe188cb51', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9ae9f076-c5dc-4a4e-82f3-5fe513021ed5', '111_Checker01', 'Misganaw Ayana', '0924525317', '111', 'JEMO BRANCH', 'CHECKER',
  decode('424b2dc34b2dcf8788fb4fca0d098d837c4d312527ac6a0d775df212c21b2eff', 'hex'), decode('dbe5257069ce583cace5872a57b5bb7e', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f9aa87f0-120a-4306-97b8-9759987a73c8', '112_Maker01', 'Etenesh Mamo Gebrewold', '0912439704', '112', 'SUMMIT BRANCH', 'MAKER',
  decode('93a90168fbf8f9eb6be8ed9b19c1d7420af3ad7ba3a8b9dc7c285b6c44f308be', 'hex'), decode('38bc90903df95a2f758f8d69ba6a0b5f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '4f30b0a0-b7bf-4172-8da5-3a5cc2c9c700', '112_Checker01', 'Felege Assefa Gebretinsaye', '0938187083', '112', 'SUMMIT BRANCH', 'CHECKER',
  decode('e8070be817677f52e9e8630b64695282c795769561b0a65bab71465470d50b0f', 'hex'), decode('90d739538b51b1151483f7ef08590b2d', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9b2e16cb-6d1e-47f8-8e53-62f887ad2b64', '113_Maker01', 'Elsabet Admasu Kebede', '0911857903', '113', 'GOFA BRANCH', 'MAKER',
  decode('4c30d7ecdaa6c3946e15a95af599848f9415cad5afd93287f5424231ee8ea066', 'hex'), decode('1280cb7607948d65344993c59658e33c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '562ec9c1-784e-44ce-97fb-2d01e100a32e', '113_Checker01', 'Masresha Endalew Tegegne', '0969136015', '113', 'GOFA BRANCH', 'CHECKER',
  decode('dcc626bdc6c144267a8ddb49ce9382e7635856a4525cf77f777c3c408e0ba661', 'hex'), decode('fe271b3b4ef52efa9513f5aeab0f4d02', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '54513693-77a6-4fb3-a457-cb7cc4759cc4', '114_Maker01', 'Wayinshet Gudisa Furgasa', '0911459820', '114', 'BETHEL BRANCH', 'MAKER',
  decode('71dfe95f61713479a0d7e6cf2064f7c6f1d0dc832b5e079f8006f6388b72fc27', 'hex'), decode('d98e33c06bab438b0cb430b758e35774', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd893aa9d-a0e2-4529-a588-6bb0ad3b234f', '114_Checker01', 'Alemayehu Degefa Debele', '0912171902', '114', 'BETHEL BRANCH', 'CHECKER',
  decode('361b6b95d8e3823ef785bc6908e3f57a0f0bd0fd22ed5a004ad8edfda11a88c8', 'hex'), decode('c62d34de93aa6cd06afddd690a011a86', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e7d4e679-738a-426d-87de-598939b7337b', '116_Maker01', 'Demissew Assefa Jufare', '0913472033', '116', 'KALITY GEBRIEL BRANCH', 'MAKER',
  decode('99698e4099e2a987d731a4143b4b8a5dc688b578a49d0f67196c78fed685c1e3', 'hex'), decode('fca92302500c3e4da29b04b305bbecda', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8eeb786d-ed43-4370-97e3-a45f166ad11f', '116_Checker01', 'Eyerusalem Demeke Abate', '0923271446', '116', 'KALITY GEBRIEL BRANCH', 'CHECKER',
  decode('0bab10178dc1af4df08489268a88456214cb77d4b84e4c5cee87b73508b165da', 'hex'), decode('879233a458b0ad7e2d14f8b0a82040cd', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '88c974ae-566e-4e71-bcac-f594d43100aa', '119_Maker01', 'Mahder G/Tsedik G/Kidan', '0936566209', '119', 'TEKLEHAIMANOT BRANCH', 'MAKER',
  decode('cf57de57c393e6874cb27e15bfce38780a70e58b163cf62e8eccc1d5fea80326', 'hex'), decode('e2e6492213dfc246aae8009ce5bc583f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9580a6bd-06c3-4a5a-bada-363fa2c88b29', '119_Checker01', 'Shifera Teklegiyorgis Mernie', '0921742747', '119', 'TEKLEHAIMANOT BRANCH', 'CHECKER',
  decode('246eeb66e14c0ef5b8559b8e1539c60a13145c1242b3f12ebdd991175f81b52c', 'hex'), decode('d3f7cfd8772bf264ff7fcfdfb70ee7ab', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '22818191-e390-4d52-af13-54e503f1dd26', '120_Maker01', 'Mekdes Teklu Gossaye', '0925958058', '120', 'BOLE MICHAEL BRANCH', 'MAKER',
  decode('25b638100d20da3bc6b79e920228cf3241debec56eb5fbc46eb704759bd38919', 'hex'), decode('5939898ccb01571c893fc250a3c38bab', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '4a2abaa8-0f40-43ff-b1ae-5550b0fc651b', '120_Checker01', 'Fantaye Ali Bahru', '0920682301', '120', 'BOLE MICHAEL BRANCH', 'CHECKER',
  decode('de29bf84fb91026b068a0c80adfdf7a856902b616fa05eb0e426577b94e861a8', 'hex'), decode('6134680644ade2e070936c197b958373', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c0c14277-4942-4914-972f-6490e5e5a409', '121_Maker01', 'Bethel Diriba Shalli', '0913020388', '121', 'ATIKILT-TERA BRANCH', 'MAKER',
  decode('e8bb9ae22cb149940fbb3c05d819079375d6fb74e2bc85e42ce6a685dad0c9c1', 'hex'), decode('51961c7feae4dcb74d6054fefd1bd2f2', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f998bd59-35ca-42c9-8552-bd4c545da43c', '121_Checker01', 'Misganaw Worku', '0903128988', '121', 'ATIKILT-TERA BRANCH', 'CHECKER',
  decode('7ce0474bc497849490c5b5620399acc6b5adc74e3074772fecc16874697a1184', 'hex'), decode('a2166b8370c344f0873c1a6995161ca0', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0982e508-b18e-4139-8dab-6f87a30d5f5f', '122_Maker01', 'Eyerusalem Fantahun', '0938502764', '122', 'BOLE MEDEHANIALEM BRANCH', 'MAKER',
  decode('ba284a12a7886f97c3f52fe330c6b0210339b52b422c4fab317d0e18fb9d642e', 'hex'), decode('a7fe2eb90582b46b0e90d4aa874f6c89', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0d688f62-b86d-4088-aa8b-a2ea4f959304', '122_Checker01', 'Shegitu Birhanu', '0928867502', '122', 'BOLE MEDEHANIALEM BRANCH', 'CHECKER',
  decode('549e52f3c5ad6f8b09554a4ba82762b5369dc6a9bf4a8bd4af93f507f9f3ede4', 'hex'), decode('83fa61fdec5eaa85a456a65bab2611cc', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0452dc98-3988-462c-97b5-b309812bbff5', '123_Maker01', 'Betelhem Melaku Temesgen', '0923527059', '123', 'NIFAS SILK BRANCH', 'MAKER',
  decode('4e79db4396ccef3fcd748a1a5834580a7cbfad1aebf08dd8fd1bd5da8b2bfedd', 'hex'), decode('0d0141a89df39b4f6757aa12387672ed', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '189a95b5-c691-4acf-9ce3-738efec67c6d', '123_Checker01', 'Haregewoin Abebaw Kassie', '0912474631', '123', 'NIFAS SILK BRANCH', 'CHECKER',
  decode('ddf3c7b4961f91486381d387f959d68801698bcf79db1022d68f5da228c4f8b7', 'hex'), decode('1b9f3f9c36e3e49af40b10e118bfc29f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f04655ab-9cb7-4143-803e-38408b55e02c', '124_Maker01', 'Kelemu Demeke Jemberie', '0915612328', '124', 'LIDETA BRANCH', 'MAKER',
  decode('25a8bf4d2bfa0e6e9236a5ceb3a2e8f441ccb23567f695c7fbce3a1195eee7cf', 'hex'), decode('b30d95b61733eacc024a8a22591c9554', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3c1f9352-9c8a-496d-a2dd-d06c6043e7e3', '124_Checker01', 'Bzuneh Getachew Tadesse', '0919980770', '124', 'LIDETA BRANCH', 'CHECKER',
  decode('180be613a9eec90f4512d96d89f1909f4fe5491cde8aad0cebf20d0b973a5623', 'hex'), decode('f346ad7c0f9d3fc5c4f7989da0a6afec', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0939a891-9a4a-43e8-9c08-250f04902a1d', '126_Maker01', 'Gelalu Nuredin', '0912970810', '126', 'KOLFE BRANCH', 'MAKER',
  decode('0d8bfa8144cd996a10c0db9fe4a93443d8966163e7704721254859ef66362d2d', 'hex'), decode('d482972fa9f18024ef0955a8d491c4d1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd7951c28-8048-4258-bfce-4f9bfa2ba51a', '126_Checker01', 'Gehad Tadesse Adgeh', '0913609347', '126', 'KOLFE BRANCH', 'CHECKER',
  decode('c8562ae354f41666c1f46e913a4bdf150f8ebcd9152e29186cfee72ac5e86f03', 'hex'), decode('897d63119d40cdc1a100d2b4c5bd192d', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'cce4fb6e-9adf-4e14-8927-655900d5de49', '127_Maker01', 'Haymanot Kumelachew Assefa', '0921600374', '127', 'LEBU BRANCH', 'MAKER',
  decode('7039be98f1d0bdba3fe62d06624768230662d63915374a836f34032545c523e1', 'hex'), decode('9192da0235dbd88d74067213816a2ffb', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8ca7cf22-7e50-4432-a7cd-0cd21812b36b', '127_Checker01', 'Lemlem Mulatu Alemu', '0968529929', '127', 'LEBU BRANCH', 'CHECKER',
  decode('5c0b689b47f3cc992dd6f2238b6c8af9a907dee01e284477cb977470e43a5c16', 'hex'), decode('5712ab541c171ae678f287c6417f2534', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f8989226-3573-41c9-bd75-6ee77303aeb5', '128_Maker01', 'Meron Yohannes', '0946381674', '128', 'ADDISU GEBEYA BRANCH', 'MAKER',
  decode('75f7f02f5c2e2868437a707a1c9f0d650b74ea9eec1a54ee0a2d4e2503f3ceeb', 'hex'), decode('7e552db0b62a78806351aa2e70af8d15', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e565fc8b-92ae-4d6e-b4c6-cb813fecdbb0', '128_Checker01', 'Nanati Tibebu', '0910491958', '128', 'ADDISU GEBEYA BRANCH', 'CHECKER',
  decode('4420d347f78342ee5c763a2f7b544c004c9f2005af3bf137d40b0de8c328e63e', 'hex'), decode('ed0b41689e4b9afc1087b39124dc65e1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '09eec169-7b15-4b56-abe9-82fd2f79f9b7', '129_Maker01', 'Shewaye Hailu', '0961017290', '129', 'WESSEN BRANCH', 'MAKER',
  decode('2f447038e6d666560152ceab5f5e5b899d7ed3aefe959d868872d2a8ee3fb9a9', 'hex'), decode('0379fee878fba037b5f097b6bd112c3a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0538b1d9-bc60-40d5-ad2b-ce0c37d7f276', '129_Checker01', 'Tesfu Yehulashet', '0919319681', '129', 'WESSEN BRANCH', 'CHECKER',
  decode('fead2f30e3629e6215f335baf3329933baf53dd17fc157bfef248b10cb2e22db', 'hex'), decode('3d3f8e9067de5b1cbd35a09d40260571', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd471b9b9-29fd-443c-a3c0-faf8e2339c3a', '130_Maker01', 'Sisay Lema Negassa', '0922767083', '130', 'AYAT BRANCH', 'MAKER',
  decode('4163391728da6f1ce7c002abd7fec5ce6f5dc8287c61481b2892a3020f8c11ff', 'hex'), decode('bd9cd5eb30c2aa5cfae3e49253cc7d65', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '848e6147-262c-4ece-9256-4bbb810a2532', '130_Checker01', 'Daniel Bizuneh alemu', '0937085521', '130', 'AYAT BRANCH', 'CHECKER',
  decode('39439deea4caf72a7dc852ff75deacb8d7fea9e33f610af233c3c1fd2d143bc9', 'hex'), decode('3550ec17862861f224d29b59d527a991', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'fead31d4-a634-4294-ae57-ec6bf56b02f9', '131_Maker01', 'Getu Desalegn Shirga', '0974081040', '131', 'GULELE BRANCH', 'MAKER',
  decode('978b7341cb57db3b74b297040065e3153cc57aa945d2eddcb5c07de87f69f36b', 'hex'), decode('5b95dbd4d9e3f6578e90bac889582f61', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8c6aa65d-b174-4eae-a154-7556295ea63a', '131_Checker01', 'Mahlet Ayele Kifle', '0922487826', '131', 'GULELE BRANCH', 'CHECKER',
  decode('29d89906ecd068ca7a8b0ca435ce1fd4c0a92698370a91c9c27a95e411c1bc61', 'hex'), decode('dbe949c5f0b7ce2b2ee87c1edfc30698', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '16cf9c7d-1714-40c1-9387-9cf6ac5578cf', '132_Maker01', 'Mezgebesilase Abebe', '0984005502', '132', 'AUTOBUS-TERA BRANCH', 'MAKER',
  decode('b7dfccf0eed9b9965730e24f986c2084987efc03e0c41769f0329b982b28a9c8', 'hex'), decode('829cd9a3d6af888bcffb0bbbb5fbf156', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '7fef4d9d-937d-4be1-b414-445561721d73', '132_Checker01', 'Abush Molla Debaye', '0911921835', '132', 'AUTOBUS-TERA BRANCH', 'CHECKER',
  decode('ed5f9a4901bfb9d8f53b3a4f99e9e2d4441290ebfaa765a4d57d236daa9c967d', 'hex'), decode('f7850301bcbb9cd4c9e386d55c22e2b1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3a5c0010-6d2c-46ff-a7cd-f2d5b43c4727', '133_Maker01', 'Mesay Gulilat Fantabil', '0987007263', '133', 'ADEY ABEBA STADIUM', 'MAKER',
  decode('532296d51fee64d5e7304bd7782383f93173f710850262679e4a7f8772cb6175', 'hex'), decode('944878a3b0175d760092b260fdcb597f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9f55a2a0-b8dc-44d0-939c-cce2194e315f', '133_Checker01', 'Kidus Yohannis Gemechu', '0917844969', '133', 'ADEY ABEBA STADIUM', 'CHECKER',
  decode('4cd241454e44f7fef47c21da1ce0b91b45b473e115bce0bdb8d99a729c86d19e', 'hex'), decode('16ced5549b874b1d35b4a52af5736961', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f303842b-1931-432f-bfd8-41aa9f46dfa6', '134_Maker01', 'Semegn Melaku Mihret', '0946403455', '134', 'LAFTO BRANCH', 'MAKER',
  decode('521caf9828534fd3001dae433e9d78f798e264d35c835d1ed2e180959945ebba', 'hex'), decode('0d0920a370d31e2eb40d22c241c40a86', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a9edd88d-1648-4aa1-9ec1-389b5461991f', '134_Checker01', 'Manaye Molla Simegn', '0921286679', '134', 'LAFTO BRANCH', 'CHECKER',
  decode('c7f70dfa6e0d557978344522808381d25e213228eb5401dd670f55af416d29cf', 'hex'), decode('5d7eccd422362e5de2a4c4e45b702e8a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'ab02b4ba-4ff9-41b9-98b1-d851a15762d2', '135_Maker01', 'Hailesyesus Tsega Wase', '0920771612', '135', 'KAZANCHIS BRANCH', 'MAKER',
  decode('7b5c036f4b15b4125608f7b37482f036e848461c111a8e66cc48f33070c2e24e', 'hex'), decode('f2e1dfb350ac85cdf33d410c0f78dfd8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '2709688f-8d24-403a-a74e-b492b6092e13', '135_Checker01', 'Mikias Muntasha Lmiso', '0916020601', '135', 'KAZANCHIS BRANCH', 'CHECKER',
  decode('65704ebba97e4899ecdc12c127e762f6943c10aa9c2ac2d55cb3ffd78e839654', 'hex'), decode('15a84bf3999bb13049d07b3077579c7e', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'acca89ba-1c00-4c71-ae86-446a34e522c8', '136_Maker01', 'Mekbib Bekele Ayele', '0910555702', '136', 'MEGENAGNA BRANCH', 'MAKER',
  decode('23b36acbd7034333d09a9ba85c275161836f0c1bc4ce65f7805606a1c380c45b', 'hex'), decode('81b4885789ea26d5e47b4acbfb4fe7f1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1b2053b4-a25c-4c74-a6e6-5e1fcb84174f', '136_Checker01', 'Belaynew Asemu Ayele', '0919998033', '136', 'MEGENAGNA BRANCH', 'CHECKER',
  decode('6899433a7640ed5f0bd24cba257186b99c50efbd0ba58f8d4a21c2428027d07c', 'hex'), decode('6f89731ef33ca17e2da22341255b8519', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c522743f-63a7-4200-9a87-f33f2c11a1a5', '137_Maker01', 'Mahlet Biru Sahilu', '0906619843', '137', 'MEKANISA BRANCH', 'MAKER',
  decode('c09b9ebefa208d52ace0671441d9e5ddd1717405c077875929d2aab5d107c95f', 'hex'), decode('a4d468286622d0a1c519365b0ae6c3f9', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '14a4e1cb-a2c2-479f-8948-ffc81d078bcd', '137_Checker01', 'Amtataw Kefelegn Taye', '0941118243', '137', 'MEKANISA BRANCH', 'CHECKER',
  decode('49f22fd369fccd435e22e2583b633ec26a653f45a615c13c93c6155c8fb57050', 'hex'), decode('a9fefc1d45d65b2874b7997f9c86329c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'eae3cbf3-9909-4cfe-a156-6353656b9927', '138_Maker01', 'Alemtshay Abera Mamo', '0986282024', '138', 'MILITARY-TERA BRANCH', 'MAKER',
  decode('117ba659e4c5b313448a7ce28d9911c2807ce7e909b909190cc8e96bf78581cd', 'hex'), decode('cc8ea00eb263fe98d772159417c73964', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '80f2850f-0d21-46c0-98fc-be7eb4fa2599', '138_Checker01', 'Netsanet Teshome Aliyu', '0921013563', '138', 'MILITARY-TERA BRANCH', 'CHECKER',
  decode('da91a0f3ad028d3c3967cc0c0f051a6cde9b97a4843d0dda5e18295d2ecdb5ca', 'hex'), decode('0a1b1f92c22d443c3bfd3afd2e96c234', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '73d8c78d-dfac-4966-8d1b-1bc6de44cccc', '139_Maker01', 'Bethelhem Mezgbe', '0979175152', '139', 'BOLE BULBULA BRANCH', 'MAKER',
  decode('9711668457c0a0bc3698d1682cf35deb7303daf6c234cfaa945e1c73d98f5217', 'hex'), decode('afee3ba49ae30712f842ce9f27ad6584', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '99cf819d-895f-4f2b-a977-28ff9ed69fd6', '139_Checker01', 'Daniel Mekonnen', '0922987992', '139', 'BOLE BULBULA BRANCH', 'CHECKER',
  decode('3cecc166c2e0ab3ee2e3c6c5dc3354a16dd4171807211ce8caa47167c9fadebe', 'hex'), decode('19bbd2099ec68b4ab9faadb71d4b55f8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c783653c-8d22-4fbd-a0fc-0cc0b5d76093', '141_Maker01', 'Manayesh Getnet', '0940333131', '141', 'HANA-MARIAM BRANCH', 'MAKER',
  decode('a276023dd9af0d61b7a8e0f25b111a39235df9fd98c0ef37fdb85d7afd2dfe45', 'hex'), decode('7924f5f174312ab8459ad2629155a2cf', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '4d1a3489-1884-4b9d-be8a-74b09f2d62fc', '141_Checker01', 'Serkalem Solomon', '0913100411', '141', 'HANA-MARIAM BRANCH', 'CHECKER',
  decode('d8f3d983b19904f4e9473e3c175f36fa26d58a8e494b1ec38d6317c472a41de5', 'hex'), decode('b240a8eff775ee384cb956cad5dc96a6', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1719d810-1f14-4e29-ad06-2f5923b9ed6e', '142_Maker01', 'Marta TekleTsadik Begashaw', '0907434865', '142', 'ALEM-BANK BRANCH', 'MAKER',
  decode('1ec22c5aab87d457118b7cae2a2d35f5408a70e1a0b10177a51107f5c644c1c6', 'hex'), decode('65c93bbc020ab48898358e3e885a4768', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5f6da336-82cc-4ac3-a865-7dff176687a7', '142_Checker01', 'Ehtemariam Aklilu Ketsela', '0918089753', '142', 'ALEM-BANK BRANCH', 'CHECKER',
  decode('380cca598d92fb26c7bc0ffd55bfe48eef0e6099271e0d33f8ab7aad1377be2f', 'hex'), decode('9fe689db965daca6aa69c604f929d027', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '6287fd04-2de7-4be9-9cda-28b914ee6ecf', '143_Maker01', 'Eyerusalem G/meskel', '0966931530', '143', 'FRASH-TERA BRANCH', 'MAKER',
  decode('6172667437a3896009be59fef0be1426038207700c83b6e5f7c35a762249f04a', 'hex'), decode('94cce86a6164f269289de847a3ce67c2', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e0e6a5d7-63b5-4eae-90de-3e2adde3f381', '143_Checker01', 'Samuel Abebe', '0964040244', '143', 'FRASH-TERA BRANCH', 'CHECKER',
  decode('00fe10ec0df1095a2d38102d17d48168a15cd1e5d464a94d7733d6a318e62b13', 'hex'), decode('96d6f001d1dd4ab1d41275acddb0fe6d', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '42263fde-e2cf-4bce-b159-4df9fcaf13b2', '144_Maker01', 'Tizita AShenafi Weldehana', '0955318253', '144', 'CMC-MICHAEL BRANCH', 'MAKER',
  decode('a5c94b26576f5035f9f0fa99bf05530f0d1b536f974d19c82339f870a6de6561', 'hex'), decode('f6eabfc359a84b300a490cd36bc2d40b', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a6fa5ef8-85c8-4fef-8b22-7f7041c74fb9', '144_Checker01', 'EShetu Beyene Assefa', '0945710405', '144', 'CMC-MICHAEL BRANCH', 'CHECKER',
  decode('1ba3ad0d18691fafc91edf8391ae8223fb9cd75d2c53e7b9f57326ac77c2430a', 'hex'), decode('359f6119dfd8a814eb934b83eebada54', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '7fb55df5-811f-4796-9341-969009b0f8b7', '145_Maker01', 'Geremew Lega Gebeyehu', '0912210995', '145', 'KERA SARBET BRANCH', 'MAKER',
  decode('8046a3bfe62ae2321d3a5beee5a17d172f07fdb1255f375c09de58fe8e66ed43', 'hex'), decode('c21eb35d45f690d3c25584832778ad44', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '08b5e119-9691-4b26-8d97-43024f660e79', '145_Checker01', 'Dagmawit Fikadu Mamuye', '0968590358', '145', 'KERA SARBET BRANCH', 'CHECKER',
  decode('62937fac3edf4e7d087d721575298b63e6d3279ee3eeab95537519cfeb4004cd', 'hex'), decode('1a86ea46884031816acfa18a488fc782', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '30d2af62-43fc-4d8c-b0be-c60e417795b1', '146_Maker01', 'Liyu Melake H/Selassie', '0910688428', '146', 'BISRATE GEBREAL BRANCH', 'MAKER',
  decode('6b328a36d7c8d16191bb31b3c0790db2c8ee0df392f371b1410f1fdce186b72a', 'hex'), decode('a7ac020440976592851f1f076c321c4f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '321a1ba0-43e7-4057-844e-c022a8b1b023', '146_Checker01', 'Edilawit Ayele Tadesse', '0901129130', '146', 'BISRATE GEBREAL BRANCH', 'CHECKER',
  decode('c8d1e28612778b5329b697f9f375936832696a5b7a041a9c56a2a21e6643c761', 'hex'), decode('8f31c794e16e4be3641ee86ead73e273', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '76e5b734-7793-4385-ad55-6e7567204ac2', '147_Maker01', 'Fenet Fito Gemedo', '0937854608', '147', 'GOTERA BRANCH', 'MAKER',
  decode('f9385c8567d152ef48c3de32ba79dcdbc234f775aa62ea9955345aeeca8661b6', 'hex'), decode('9c317a7dbcaf84cc9fda1d57d3e134ef', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'ad9e1fef-28f6-4dbf-9b6b-dca2f7578f26', '147_Checker01', 'Meselech BemirewZelalem', '0920241180', '147', 'GOTERA BRANCH', 'CHECKER',
  decode('bf20fe9abfaedcc54c467a0fed4806ad56cf24294581928c144a2ebc8947d11f', 'hex'), decode('374a9d76cb6bd42e1e2398a41b61d5db', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c0480a6e-3d0c-485e-adfb-ba627956e2e9', '148_Maker01', 'Betelhem Sisay Beyene', '0984861366', '148', 'KEBENA BRANCH', 'MAKER',
  decode('6406649afa0f70da0b96558a2c32082d131a74f215e010fac33e774b3a9a3bf1', 'hex'), decode('981cd200106a76224d110fa49d3f2371', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '6c7524de-7287-4791-85b1-d1819813b856', '148_Checker01', 'Temesgen Abay Ayalew', '0947064531', '148', 'KEBENA BRANCH', 'CHECKER',
  decode('378953b585176f9ec067d5e918093903a0a14a38f3dba96f94ce2fd8304dc5bb', 'hex'), decode('fd1bba9bf2f531c9a43a47427790d3a9', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'cee35d44-ead1-4e3e-bad8-35d9eefa7537', '149_Maker01', 'Tewabech Workie Beza', '0974064701', '149', 'AYERTENA BRANCH', 'MAKER',
  decode('11cb75206bb4925866de5513f0cd3373eb2234089017e0a5b3ab3f2072ab72f6', 'hex'), decode('8bd847b8c63b3c92ee78dbb20b2ea645', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'cf5f8f8b-6fd2-4682-9db9-a2a1caa5b5c8', '149_Checker01', 'Elias W/Gerima G/Eyesus', '0919163448', '149', 'AYERTENA BRANCH', 'CHECKER',
  decode('666a5445724cd7c1b986a2c7134311fbbace22a5e2606fc8b54547d41e8d89a9', 'hex'), decode('bd2f45e040a77ab3c8ed968648c2d4d0', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'ec472af9-5d08-4e2f-837f-ff7f35497411', '151_Maker01', 'Girum Daniel Kerebo', '0935023666', '151', 'LAMBERET', 'MAKER',
  decode('963a08b4082c8647a6577bc1c8237027ac914d89d649a4e0ad2da917fa226116', 'hex'), decode('8e88c585f95236dfdc1252afd514ae80', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '257d481f-6627-4b86-ba43-8943ce324e7f', '151_Checker01', 'Mekdes Hailu Teklu', '0934473606', '151', 'LAMBERET', 'CHECKER',
  decode('d69fed61eeb5c2f8a9b72625c2694bba6b0e050a678169c5db53013880299e36', 'hex'), decode('f4e6ddf1973ea04fb6c76a7bdcd86637', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd85b21c7-063b-4e35-9c10-679273d15be1', '152_Maker01', 'Genet Tadesse Teshome', '0911466410', '152', 'ARAT KILO', 'MAKER',
  decode('dd5739c8df67527ec952bee3fe40929b86a929ffeaf842e23a12457ba2a12566', 'hex'), decode('6945b630593a48c2ffd3cea1601ccdcf', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '29882dbd-f47e-43d9-9f97-e84027e8ae3a', '152_Checker01', 'Debritu Sorrye Amdework', '0929950022', '152', 'ARAT KILO', 'CHECKER',
  decode('ff354de799b8b9fe0d0ddfcbd42c08d35df6247b9571a71c347d9f12b23a8bba', 'hex'), decode('730623642c7e0d5c702cd07a59ecf84c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd0f42fd7-d24c-494a-a19b-bcc3dae69d6d', '153_Maker01', 'Tesfahun Markos', '0910984070', '153', 'JAKROS BRANCH', 'MAKER',
  decode('c7f895c2bf2613d7210f157cc75f43977ec25c48cabf0ce74949bfdcba3ff385', 'hex'), decode('bbbfb71b91813e5a74624b3371b72042', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd197c094-094d-40ce-9d9e-3329a59f3ee7', '153_Checker01', 'Etsay Shiwaye', '0983316771', '153', 'JAKROS BRANCH', 'CHECKER',
  decode('9fcfa07d2fae896cce989a0ff37ac730f17b9628be6223f924573c54ae69d918', 'hex'), decode('993ce6b5ab50e657f15f7b232458a505', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0b0a73d6-f960-45d1-b480-21223b85261d', '154_Maker01', 'Erediet Mebratu Zeleke', '0965325231', '154', 'AKAKI BRANCH', 'MAKER',
  decode('3334fd91258699d73d61df6131bfb5f512fa76a3043f89ae53b04889c740e7cf', 'hex'), decode('b55cc62f158b1c071be676e1c01fb8da', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '206fcb26-ac67-477b-8edb-397c0b7ac4a7', '154_Checker01', 'Kemerya Sunkemo Lale', '0921399753', '154', 'AKAKI BRANCH', 'CHECKER',
  decode('7c4031e5e11de145156187a18d8838d750486d8232fbef15d47ef938abbef37c', 'hex'), decode('7fa14345b157e0f67d9ce28e17461234', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'ec383e19-0586-42b9-9416-78af505216ac', '156_Maker01', 'Yigremachew Seiyfu', '0903060325', '156', 'CHURCHILL BRANCH', 'MAKER',
  decode('b35fecf73bc5aa2c24a09a1010eaf44c44672b5b7222781d5173efaa688f4a1b', 'hex'), decode('ce04a2be52bffe7a5e79e17460b7e5f7', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'cc8fed41-187e-4b54-856c-09acd7bc6964', '156_Checker01', 'Dereje Gobeze Melkamu', '0912842255', '156', 'CHURCHILL BRANCH', 'CHECKER',
  decode('88b44a666c000367cc0940ed3ce643f8ca4da59a8cad61750e89e517b6ac948f', 'hex'), decode('5cca42a6a1e8d7e226615426618fc0e4', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a52c4334-b7c6-4ad4-a0ca-e5e6ba1b97e4', '157_Maker01', 'Yemisrach Worku Sebhat', '0911096553', '157', 'DEJACH WUBE BRANCH', 'MAKER',
  decode('520679a0575bd6c519acd0c2cf34d6f3c8493b285a452489fb7c89cf1ee083fb', 'hex'), decode('60d529f82cf3cdb82f47da109eaa6fd1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a7951eda-084b-4adc-96f2-55f9dce3a1d7', '157_Checker01', 'Zewdu Guadie', '0928570144', '157', 'DEJACH WUBE BRANCH', 'CHECKER',
  decode('f022620e5d566e4e3ed07d2c4a93319044d31c6bdc265899746a2fbd91ea6636', 'hex'), decode('abbe71fc6a66b3f19e66b28a2ae143a6', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e25a6e59-fbce-469d-b694-f81e759bb443', '159_Maker01', 'Yeshewareg Getiye', '0941392934', '159', 'KOTEBE BRANCH', 'MAKER',
  decode('28b3428f84a0a23836ee27e97afcfb2ba1d9b386dd4db319177f6a1e44663b0d', 'hex'), decode('215161606030ea2026e7d272ed688d1c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '535f30d1-8455-415c-ac8d-92eeebaeccb3', '159_Checker01', 'Rediet Belayun Ababu', '0961105019', '159', 'KOTEBE BRANCH', 'CHECKER',
  decode('9731e84d90cf7904b82c6edb5538ab2bfe26ce23fe08aeb497dcd2f1ed8e8c0a', 'hex'), decode('a2afcdeba602e3206a63785c02c3596a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b6ed6bc3-6033-4199-afaa-b4e22a95e7fb', '160_Maker01', 'Aynalem Gashaw Minda', '0991130970', '160', 'FERENSAY BRANCH', 'MAKER',
  decode('e875dda4cfdf7403a3a964422b7f83ee15892f14062ce10de8584160ddc7a25f', 'hex'), decode('7650221fe5cc861a746982ae9a6fe282', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c779de72-da4e-49ef-88b2-7980e0d32a0b', '160_Checker01', 'Kibret WOndemagegnhu', '0903488600', '160', 'FERENSAY BRANCH', 'CHECKER',
  decode('d0072916f6d777003efcc14ade7685c9045e9be4e54b2d95f640e74c76cb659e', 'hex'), decode('214419aebefb77646192fbb54a3e29c7', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '7e39e087-1da0-48b9-82a9-d04035dd0098', '161_Maker01', 'Firehiwot Dereje', '0988344215', '161', 'TULUDIMTU BRANCH', 'MAKER',
  decode('415e8b2097f6b18b69cbd313f682ee6dbc815d2f5a79273ad71af86d85d69405', 'hex'), decode('d78ab1e5d6e203c8a056041621061dba', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0830d77c-b4f4-4c9b-a950-034e5222b13f', '161_Checker01', 'Tigist Basazin', '0985655562', '161', 'TULUDIMTU BRANCH', 'CHECKER',
  decode('3dc1381831ed9ccee375d409eb7e215cf252049ffc3b5b937dd79b57d6548b91', 'hex'), decode('3208e8ed726581daad7d2a5d79f30d17', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1b1903ea-3c2e-42d8-b62f-492a7a96b705', '162_Maker01', 'Baweke Adugna Atalay', '0965686809', '162', 'CMC BRANCH', 'MAKER',
  decode('f347693c419b3b4f66e393a415287fe793bdef9b22d22b09b9ce090f1cceff3e', 'hex'), decode('4c88558bb8c862c621e6bdbe413878ff', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0407567c-2d2e-4f74-b0d3-a01315102754', '162_Checker01', 'Getaneh W/meskel Atinafu', '0909093683', '162', 'CMC BRANCH', 'CHECKER',
  decode('b191db45a82d673b93b726f486ee1c6d450286650a04e5c1c02807894275917f', 'hex'), decode('7a0144d2023dd165b216a2120ddbdedd', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '562ad1e0-d838-49a7-83f2-86b9bb94a6b6', '164_Maker01', 'Abigiya Regassa Terecha', '0942397589', '164', 'GELAN CONDOMINIUM BRANCH', 'MAKER',
  decode('f1cb8d1e3eb07e74531fe9eb244d5270ef06e609350430673794e16f41f00cf4', 'hex'), decode('b0693c6092f593de172e39f1fc040594', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '00bba573-2962-4326-818e-542f5f3954e0', '164_Checker01', 'Shelema Asmamaw Felu', '0940562892', '164', 'GELAN CONDOMINIUM BRANCH', 'CHECKER',
  decode('c42e4643dfc900ee62c32d04cf3fe00f0de5a89cb31075a297b75be466054754', 'hex'), decode('8db47c095f6f611d08c02a632533220d', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'fd06d2d1-a391-4bb6-8792-4c1d8e72ff35', '165_Maker01', 'Addishiwot Tilahun Beshaw', '0941181813', '165', 'GORO BRANCH', 'MAKER',
  decode('69dba00788117b9438f0025673741576147b0d258d5476cb0b6de33d3add07c2', 'hex'), decode('d72cf00ea8930f46f019d45f89e0c416', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd3365670-5bc0-4bf9-b640-233a4e9647b1', '165_Checker01', 'Faye Adamu Temesgen', '0922150289', '165', 'GORO BRANCH', 'CHECKER',
  decode('34f99d4104e51783d66eff6180c50d2b998efe0fcc200b19590832bc23a273dc', 'hex'), decode('55df2e9fb88f15d41ab2331782feafef', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'da7bf661-aca7-46e7-aa06-5b064673c042', '166_Maker01', 'Tadele Asres Tiruneh', '0989546989', '166', 'GURD SHOLLA BRANCH', 'MAKER',
  decode('e2e1d3cd1b25f511b8d666778ff7b0a23b048e4f916d4f128682bd4bff3854b8', 'hex'), decode('aa47c78dde7f3b6774c3ac736dbcdac5', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '60e9c410-1854-4d46-a197-5fceff802ba2', '166_Checker01', 'Abinet Sileshi Ademe', '0911143976', '166', 'GURD SHOLLA BRANCH', 'CHECKER',
  decode('413b693429b8a32fe7727a5699cee1065a35fd09e4a815411310f199bce83b13', 'hex'), decode('c7295b731fbf7871d8bd20579b6a17aa', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '963c457c-a497-4097-9059-6f2ad4c7030c', '167_Maker01', 'Hundera Zergu Adino', '0990237721', '167', 'YOHANNES BRANCH', 'MAKER',
  decode('a07e313088e7165db73f1ac549a8f5d1def1adb2280c591f4c7814c0fe7c408b', 'hex'), decode('079017c9cf3ea2c75460a2af580f3425', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c4471a6e-3a06-4bb8-ace7-ac2bb014cf32', '167_Checker01', 'Esubalew Dessie Ejigu', '0948735923', '167', 'YOHANNES BRANCH', 'CHECKER',
  decode('00c0777089f07156a07dc091c1e566293d042f5078566ea1ce7b56ac73bd7835', 'hex'), decode('16dcf345db8798c89adb6ae9c88135ed', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '17696af3-6724-4cc2-89e8-dc77c42694ba', '168_Maker01', 'Hana Alemu', '0920126543', '168', 'WUHALIMAT BRANCH', 'MAKER',
  decode('f0021a40cc00084070dd4ae0f65cd8423894dbe696dcf53bbbddd1c2a120cd20', 'hex'), decode('fb40df349e12c2c4d20049a6131f25f4', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '4f6c6159-9b18-4d3f-9889-eb38092f7f7d', '168_Checker01', 'Eleni Dessie', '0975063100', '168', 'WUHALIMAT BRANCH', 'CHECKER',
  decode('9ecde9043c25c6ab4b331a4de46bfd1ab3454351292cd2d4b97194e35f8d6429', 'hex'), decode('6485784337fd803b4435805bcc95a9b5', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0ee78924-17c3-4df9-a53d-fac53aadaedf', '169_Maker01', 'Gebrewold Worku Bereded', '0934225731', '169', 'MEHAL GURD SHOLLA BRANCH', 'MAKER',
  decode('860a38af5039b78f058e74a30d5660744cbdd35a153acd88de8645f991d58811', 'hex'), decode('a11e3fefe498f5c18f18958cdacf4aa8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'dd12559a-013e-4225-880f-cc958592b4a7', '169_Checker01', 'Kifle Mandefro H/Silase', '0937807560', '169', 'MEHAL GURD SHOLLA BRANCH', 'CHECKER',
  decode('080beb1a21f72b8f874536de8d8367efb6f53689df3eaa58cd18dd4199449152', 'hex'), decode('a77c058ade07400d0e1dca2a0fb583ed', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd1cb9e3b-f6ae-4e84-98f1-a383b010a2de', '171_Maker01', 'Tibebu Yalew Abie', '0939075296', '171', 'OLYMPIA BRANCH', 'MAKER',
  decode('8bf8a49ebe5a5d7a18d37482fb656266e47eb7ec2b2903ee5029de7b9bef8344', 'hex'), decode('e71e94f012291d4f06081d83b568ad72', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'bd0c6174-39cf-44c7-8eab-47b770c3620e', '171_Checker01', 'Andinet Atoma Asefa', '0924685741', '171', 'OLYMPIA BRANCH', 'CHECKER',
  decode('8db122a6f9579d2578dc5987ee675c347ad132b9705e542304d07a786ca826c3', 'hex'), decode('067e4e380e54c38e29f5917d4c424ea3', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '2424b501-65db-46c9-9a75-865ea5131e1c', '172_Maker01', 'Azeb Tesema Zewale', '0943894968', '172', 'KIRKOS BRANCH', 'MAKER',
  decode('b751018407c13a947fc2685e99889888cb80f36c84dc5a37f6de1caff89f5197', 'hex'), decode('08ea9af7b614f7bd8664c5ac91b06b1f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c6563f07-c011-4961-8882-87c5843b188a', '172_Checker01', 'Andu G/Silassie Bereka', '0987074059', '172', 'KIRKOS BRANCH', 'CHECKER',
  decode('24b6f7f2bd439047fb8c01a258f3c49006534bccc5273a24bac23248c49ed738', 'hex'), decode('efb76a69801ae775ae73237417f3adae', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'fa773be5-3ab9-40c8-9927-f90418193713', '173_Maker01', 'Fikru Nigussie Bedada', '0965332165', '173', 'WELLO SEFER BRANCH', 'MAKER',
  decode('dc48b1cfd86baf54d352de854f8914118da0bffdd527dc7e4baf7cceefcc761b', 'hex'), decode('b9c9cb34d353d0fb598675a6b8484d14', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0ef62a23-3f05-4896-8387-3a8b7597cf88', '173_Checker01', 'Samuel Sema', '0913034901', '173', 'WELLO SEFER BRANCH', 'CHECKER',
  decode('f1a616b481360d5ad30e9fd82aaeac71e3c0da1bdb1dc7d6086e2ad4a66bff38', 'hex'), decode('a7da0f8770860974cd2be6fbc3861ab2', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b84213e5-11e8-470d-ac03-4a9dc571a496', '174_Maker01', 'Senait Dadi Daba', '0984000355', '174', 'AMIST KILLO BRANCH', 'MAKER',
  decode('0ba68ac8e4d8999ca1d280620a457177782290e5ebc8b373fff108fe258ed324', 'hex'), decode('02b7d9b3b2162d95d0b75fd14831aebf', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e39b2163-c214-4420-87d9-47b8475df11b', '174_Checker01', 'Mekdes w/senbet', '0920743831', '174', 'AMIST KILLO BRANCH', 'CHECKER',
  decode('ad4deb53e2868fdd04206971e39555a795f65d966e430848b0b969f1c0605fe3', 'hex'), decode('c52af221470c63594ac8928365002f5b', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'aa816299-b2e7-4cea-bca0-7012c114a4e8', '175_Maker01', 'Alem Bekele Megersa', '0919389565', '175', 'SHOLLA GEBEYA BRANCH', 'MAKER',
  decode('4b23c864e1af8965ee04a08c48e7f9d0c45e4b73f6aa8b8b04332dc0eca5b858', 'hex'), decode('d0c79e79fd2d7efe178ae077974c6b11', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8e60f4ca-b614-42c8-876c-f304c3cf4823', '175_Checker01', 'Menen Getachew Asfaw', '0910860624', '175', 'SHOLLA GEBEYA BRANCH', 'CHECKER',
  decode('821d19855ceb48b34a13687e18a683870780d4a13ff77f9088fca02c31f96c35', 'hex'), decode('736bc104d0aefbb9b1e09862b83fc4dd', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a70f01d8-cde3-4d2d-83e6-b3d541a4bab5', '176_Maker01', 'Endesew Mebit Zewudie', '0924874287', '176', 'BULBULA MEDHANIALEM BRANCH', 'MAKER',
  decode('8e2d4458040ad280ccda1e26271d7ef6c12d06f53a2ba4946e6110539c9c172f', 'hex'), decode('f49e4db098063568add60c66df41f1e7', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c40ff004-a7aa-4459-904d-8b9c8296e412', '176_Checker01', 'Haileselassie Abeb Ashagari', '0920378022', '176', 'BULBULA MEDHANIALEM BRANCH', 'CHECKER',
  decode('32bf655b5710f0421034100d52231a963bdeff2ef2e1dea5e0e85ed4dc9f01fb', 'hex'), decode('e897dd440d1d8317f09585e0f46967b7', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '89483e23-5bc6-4ad8-9dd1-11ec1a18000c', '177_Maker01', 'Tibletalech Adamu', '0919618175', '177', 'MEGENAGNA 24 BRANCH', 'MAKER',
  decode('d5b83ac4491ea0dd700a8a7e60cfa59daf30d2d78e6017d3318a4ecde977f203', 'hex'), decode('014345f7f03bbce987233225a32500a0', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '6b01cfed-e62c-4246-a6f6-fcea6996e137', '177_Checker01', 'Efrem Tamirat', '0913750949', '177', 'MEGENAGNA 24 BRANCH', 'CHECKER',
  decode('5cb927bf3b318407282db23a9d19ed06bc20ffbe9395ec35f832cc8075b828e4', 'hex'), decode('4969d131953a4b22fa70949abc49d5de', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '300d394d-d9fc-4145-963f-6310f548b10b', '178_Maker01', 'Natnael Kaba Beteri', '0991888981', '178', 'AYAT TSEBEL BRANCH', 'MAKER',
  decode('41cf4c1b1f69f7a8407c9229c9d63c3901be1176da6abdc5b01432c26dd3e49c', 'hex'), decode('5083513c5715a1f81f311d5b1538896a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '40755621-9e69-425a-8aa9-bcdf9d84675a', '178_Checker01', 'Woinshet Gobena Gemeda', '0912197503', '178', 'AYAT TSEBEL BRANCH', 'CHECKER',
  decode('ebfe902dca2f04cd2babc0baa9dba85f01dc45522a0b86f29e49de623e569c25', 'hex'), decode('65b7ecfc4193cab1f7a709db844af24f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a4f2e3b4-784e-4ad0-a226-5c5c6ab1fa56', '179_Maker01', 'Hiwot Yohannes Workneh', '0991902549', '179', 'AYAT 49 BRANCH', 'MAKER',
  decode('7dd7a64002d4813ff357aa6e54b615cfd652e9cdf1ac689ce55bdc7a2876d60b', 'hex'), decode('f4a40d1a563f6d2b7bff5d208da8925b', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e71dff7d-1563-4150-aa14-2c1601ee07e5', '179_Checker01', 'Temesgen Yaleqal Ayal', '0901154040', '179', 'AYAT 49 BRANCH', 'CHECKER',
  decode('a06d0723371e136550c327ba6b6eb04002d9e8caced4a662e1fefc8583fffd58', 'hex'), decode('4ca346bea240d90c4fe075ef6d57c97a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'fd73478b-dcff-4774-9bc7-dc059a7ee1c1', '180_Maker01', 'Desta Wedaj Debash', '0921780612', '180', 'YEKA ABADO BRANCH', 'MAKER',
  decode('a3ffec53f6b9604c89a842066582aa8f92b693f6604e3194c678c2c2c67a59a0', 'hex'), decode('453d2e49a28f2db603b888218e12c5c6', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '30b9d6b5-b784-4f38-bc3c-8e440188f416', '180_Checker01', 'Kumelachew Alemayehu Kebede', '0915841080', '180', 'YEKA ABADO BRANCH', 'CHECKER',
  decode('06a4d0136fb11567f50c807164aaf00bd51cadb9bda694391576f28ba17228a4', 'hex'), decode('1ce82d3bfe8f95484b6b2ec402489349', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3fb4a1bc-6007-4753-8fa1-df4c5278b846', '181_Maker01', 'Tigist Abebe Tenaw', '0932298071', '181', 'TAFO ADEBABAY BRANCH', 'MAKER',
  decode('589821baebf503300b3bfd3af1fdad0713c8da09775911e730981e98f862ef17', 'hex'), decode('89e805e24f4abaa91e23e2f756f99525', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '6f81dd7d-68cc-43a7-b7d5-cf61aa427070', '181_Checker01', 'Samrawit Muleta Tiku', '0920861444', '181', 'TAFO ADEBABAY BRANCH', 'CHECKER',
  decode('093593405dfd32e9f85831d92d5e5f23e101f052411d7edacc1d824dc067ce61', 'hex'), decode('84e91320c732f94480e5f5ad50ef24de', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3468bf84-37f4-4fe7-85ba-112328743d38', '182_Maker01', 'Addisie Mitiku Sewagegn', '0920311522', '182', 'GERJI LEMLEM BRANCH', 'MAKER',
  decode('7176117c814c1236277d5e518b7c8c38182a6aabc531e30f7e51565f64131f5a', 'hex'), decode('d679de54c805f6f120c9ad0e6d9e1d84', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd6cabcf1-094f-40d2-bf34-96929f6eb412', '182_Checker01', 'Lidiya Bekele Negewo', '0913053478', '182', 'GERJI LEMLEM BRANCH', 'CHECKER',
  decode('c338fedd37f25daf0739b21f2343f0ab98177bd0b7aa519e04704fa824b9c6e2', 'hex'), decode('4c8bd85c06c1d316bcc49c324f5a141b', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8adc06ab-0868-477a-a83c-38c464f9ed1e', '201_Maker01', 'Muluken Zewude Haleko', '0928762611', '201', 'HAWASSA  BRANCH', 'MAKER',
  decode('09c91cf9fdfcf6154f5741b8b014c74fc3cc93ad5ee8d12686f5812c356b6996', 'hex'), decode('d8da8adf88dca715ef379f83db76c46f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'ddcbe11b-ad78-4a59-bf65-1cdf4e48a3fe', '201_Checker01', 'Sewunet Yohanis Gechane', '0925142907', '201', 'HAWASSA  BRANCH', 'CHECKER',
  decode('4d06ee76f8b4ba8616a6bf792068896d9795f32b914ef7da872692e376a7cbaa', 'hex'), decode('1a93858e2cbd42afc751d892e0af482b', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '2537ffec-5fb9-4158-a4f2-bedcbb8e015a', '202_Maker01', 'Ayele Taramo Wochaso', '0926271829', '202', 'HOSSAENA BRANCH', 'MAKER',
  decode('9c14aebb43ae5abfb6af4e412fe114f5b7f0851337b751d409f0ec3f5286ee3b', 'hex'), decode('881079bd3e94d19aa80ee7b340b138a4', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1fe95e58-e9f6-4641-b335-04ba5e56a943', '202_Checker01', 'Mathewos Abiyo Ertiro', '0913663160', '202', 'HOSSAENA BRANCH', 'CHECKER',
  decode('4dbbe68ba31c3c27b4752a05764202b0215bff2264cf95686b714895927ab8dc', 'hex'), decode('41a02b65172e7b247bbd020a67656331', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '79ea2950-afe2-4e54-83ad-d446167ca620', '203_Maker01', 'Henok Benera Langamo', '0912505159', '203', 'YIRGACHEFE BRANCH', 'MAKER',
  decode('ab5cfb8730b323ec28baa33c1195ba657e4995e4c040fc2406b615c8ca0a083f', 'hex'), decode('d54724e784389cd257992a59e81ef178', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '4db43d6c-8714-47cd-8512-a77b8fde143f', '203_Checker01', 'Demiwoze Duguma', '0916924453', '203', 'YIRGACHEFE BRANCH', 'CHECKER',
  decode('e09b81a358fd2ee0a58521763e6c7dab1d82efd0b1cadedcadb68f31c2bc7cc0', 'hex'), decode('b75a05b6a36fe2f50575f79d47890f1a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'fb9e6422-3928-4287-8150-dadf9fcb735b', '204_Maker01', 'Mekides Abebe Alaro', '0910332899', '204', 'WOLAYITA-SODO BRANCH', 'MAKER',
  decode('7fd2621dd651fd04edd638617625053e4a9244eb7af0c1a48b56990ac4c1b745', 'hex'), decode('3b612b25c44aac6efea64f08a9b94a54', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e999d953-6007-4037-98d7-eb22f85c41f5', '204_Checker01', 'Azmach Tekle Jobiro', '0910120991', '204', 'WOLAYITA-SODO BRANCH', 'CHECKER',
  decode('76f501d8599f93ed4a0bc5127803f609cf2ce7cd9372895450d5746f23f433be', 'hex'), decode('5dc8564a9b35cbf81882449de8b5c55f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8ca19fac-b6ea-4914-8b9c-d166d466bcea', '205_Maker01', 'Yoseph Ayele Bali', '0910132653', '205', 'DILLA BRANCH', 'MAKER',
  decode('1619ac457c5c963cdb7b9b440c495002f6c1002ee9b99007544769f0775d9dce', 'hex'), decode('4c1f82a3da67fee7e24c1cbf5789c64c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '08aefbb1-1cf1-48d4-9fcf-7068c1093d20', '205_Checker01', 'Abdulselam Muzeyin ali', '0928804945', '205', 'DILLA BRANCH', 'CHECKER',
  decode('7d8a1f8bc8d52a83bd83230d3a342eab963b214d285c38c0dd4b3814ea06c09c', 'hex'), decode('12148dfc83132422f86062efbc7c04a0', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'ee87d052-c2ac-4671-b279-5700f7e3e487', '207_Maker01', 'Merid Matelo', '0915622221', '207', 'WORABE BRANCH', 'MAKER',
  decode('8924db0b80a4f5a800d4391cf3817163ce24dc7f4c931e759a7c62e73fda6ad3', 'hex'), decode('d10e1a15117efebbe15f09d4ebbcbaa8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'ea7f07ad-b581-4ee9-921e-5ee727e35994', '207_Checker01', 'Desu Safawo', '0965501555', '207', 'WORABE BRANCH', 'CHECKER',
  decode('15c6b7b5ba8df673fdf720a7e986bea9696845b08d76b596d1f0a21516ce88d4', 'hex'), decode('dbba8321ba0e5c5c0a4f5008ffbe3311', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a5455a57-5c7f-4857-b50e-1b5ab554d04b', '209_Maker01', 'Meskerem Tilahun Tsegaye', '0916059901', '209', 'SHASHEMENE BRANCH', 'MAKER',
  decode('9e2400306724b69722b583016daf58214be13ff66dee7c5b1f6884278e1a96a0', 'hex'), decode('f7afa97a102bac9c4ec2f86fde4179eb', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c686c5a4-7882-4073-9bd8-d36efae252a1', '209_Checker01', 'Selam Tadesse Bekele', '0919656160', '209', 'SHASHEMENE BRANCH', 'CHECKER',
  decode('85e5337c55fa7ef34dd4caa6b230e7aac17be8d9fb82ccc97326ed894365cb00', 'hex'), decode('3da770b7175446b1ea038b44330d980a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1cda1fd0-14bb-4985-99c7-a5f88180fa3a', '211_Maker01', 'Andualem Ayele Belay', '0926064335', '211', 'ALETAWONDO BRANCH', 'MAKER',
  decode('c5e18fc2702ef5b6b192fd031257a54dcbe83d59f17e09aca66eb3b161134018', 'hex'), decode('a9ab4b3cb4a7f44692ab7f430a3c0565', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3b90d15a-8ee0-4257-b408-222b68722873', '211_Checker01', 'Roman Mulat Neway', '0932611998', '211', 'ALETAWONDO BRANCH', 'CHECKER',
  decode('2cc3e2188e4ebcafe71b2106dfbf29825b3e468b601dd357c747d89a9c6b59ac', 'hex'), decode('54e4f8a2a5cd232dac9ea9d520a7d842', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'eabeba05-01be-4569-90da-b83d1a84a275', '212_Maker01', 'Henok Solomon Ledamo', '0926387407', '212', 'YIRGALEM BRANCH', 'MAKER',
  decode('aa79b2e60072604cec9fee4d8cd1080ab117be246ffc86ac9863fdee86f77107', 'hex'), decode('7014a53336da9823e07967627159aa93', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0c2f734f-6372-4e5d-8c22-dfc893741eb5', '212_Checker01', 'Petros Bariso Batiso', '0944751767', '212', 'YIRGALEM BRANCH', 'CHECKER',
  decode('be5a72e52c8d744c6d20ac8f9458bbb3e4f8aee0d858b2a24971aa5b2d1f3654', 'hex'), decode('c6e9f8f738364bfe776a68379a1667e6', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '730b21ad-4bd7-4dd9-9cf3-1bf9ff6586c3', '213_Maker01', 'Ruhama Asefa', '0919332506', '213', 'ARBA MINCH BRANCH', 'MAKER',
  decode('3aaf808c08b66b10af0e5d55eeb4411e49844b09a995f9b336eebff455a9f716', 'hex'), decode('c5088c90b8448973bc2a6e9c77f13e68', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '20fa0485-8c0f-4d27-967c-dd549d717b95', '213_Checker01', 'Tesema Tadesse Mekonen', '0911638853', '213', 'ARBA MINCH BRANCH', 'CHECKER',
  decode('622d343381cb003b93a7b4a9b7faf71e66c12daea3374cb1dc9dcc883072db62', 'hex'), decode('66a04b531b974b628c23f150538fa6b2', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f2c5310c-bfc5-4b3b-a245-2aadcfb6c8c2', '214_Maker01', 'Tekile Shoa Sadamo', '0934772182', '214', 'TABOR  BRANCH', 'MAKER',
  decode('4063c6347f09767353b5e93d7d0132d38a1e47a6d892116b5f6e813fbde395b9', 'hex'), decode('0620121a2fa4bb17e20974331fe67798', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'cd7a8e33-30f6-4dbb-98a9-bd34dea3cf67', '214_Checker01', 'Konjit Mamo Chala', '0976096002', '214', 'TABOR  BRANCH', 'CHECKER',
  decode('2dc92911aafdbc4734971f7a458b190589314f12ec3fbcad4bdfcd13e02bb972', 'hex'), decode('a77a7968d71f07db97da9819b92b1ad8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'fb36f322-7c39-4b59-b0bc-3bad5ed5d746', '215_Maker01', 'Siraj Hassen', '0911792826', '215', 'BUTAJIRA  BRANCH', 'MAKER',
  decode('e1dea6c20b763d5d274fedb9de3f82d4ebb5250bf2c080f0fd7777ef546718f0', 'hex'), decode('4277252cf61c26d704b95a3fe6f2f9bb', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '97a34d7f-c04a-492a-b9e6-b27398e2dff2', '215_Checker01', 'Yosef Bilhatu', '0946948162', '215', 'BUTAJIRA  BRANCH', 'CHECKER',
  decode('2c5e4db770aaa629057255d7d2babf2b28ce354a46ea86092f736757355689c0', 'hex'), decode('1986b0064c584785d63338eb695578ef', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '2c9a3f5d-3786-4b97-b2fa-03fdba112502', '216_Maker01', 'Bikiltu Motuma Olana', '0972529305', '216', 'BISHOFTU BRANCH', 'MAKER',
  decode('6b9a95864ec4cacc50f3904cb88111b6c843ba44ceb02dfb8935f54c42684895', 'hex'), decode('90795a8545c04ebc7c853bf279f9746c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '11e13b21-b5ad-4285-9273-ea04adbb115c', '216_Checker01', 'Hiwot Arega Kassaye', '0929199909', '216', 'BISHOFTU BRANCH', 'CHECKER',
  decode('0028e389b87ca913c48566c101ce407f724fdc56865f8184dc4e92db9f5acb2b', 'hex'), decode('41f63bd8b2b124f9303373dc3232e159', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '394509e4-2b7e-4a58-809c-ddd372b2309c', '217_Maker01', 'Elisa Temesgen', '0912880912', '217', 'MENEHARIA BRANCH', 'MAKER',
  decode('91a26f4617cf48bc246e348872c072f7acbd1c58aab985537eb8582af99583a9', 'hex'), decode('92e4ae7cbe53ca88f1bc99c20448827f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9694cd8c-1a23-4bc2-a483-bfe526bb6bb9', '217_Checker01', 'Meharu Markos', '0913392984', '217', 'MENEHARIA BRANCH', 'CHECKER',
  decode('2e8169b620dc363ddc3931223c9fe7cad908999944f6a52bd026e8e390029605', 'hex'), decode('89429493f26039b90fdd7f4f7df3cf41', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a34157b6-bb5b-4a75-952a-cf195ade91a7', '218_Maker01', 'Chali Sori Abdera', '0920413380', '218', 'FURI BRANCH', 'MAKER',
  decode('dfcc62c1c199c98f59824ed33ab615b5af07f09b18535145428890af7425a5bb', 'hex'), decode('775521e02b8fcdcd00e7ba46d7828239', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c6b2de64-e46f-4185-ba4b-5ea0331b399c', '218_Checker01', 'Jiregna Fanta Nemera', '0919130355', '218', 'FURI BRANCH', 'CHECKER',
  decode('14dfdc403eb93bb4acdc5d0487f5e85508a769e82da710bd09be4df104d4471b', 'hex'), decode('74a7ac5eaa5f87de0fc3f0c1df4c1566', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5ad5cfdd-87c0-49c7-b2b8-ff59b8f06fd1', '219_Maker01', 'Edile Mamuye', '0926539465', '219', 'HAWASSA ADDISU GEBAYA BRANCH', 'MAKER',
  decode('46e2ab8d5d8433ae1041cd99f81cff6c8d801db35e963e5151596521c7fb4319', 'hex'), decode('80df9bef6a86f3e926c02d5477a84670', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '47f7c24b-b8dc-417d-9042-ff34e1f41031', '219_Checker01', 'Naod Zelelew Beraso', '0913907200', '219', 'HAWASSA ADDISU GEBAYA BRANCH', 'CHECKER',
  decode('0d1520fb93dfb74ba775c27802e725ea5c313dbe5308df85b8d6b17c85e7a3eb', 'hex'), decode('2f751203b81e480eb29124b9fa28f8fa', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '7d190ec5-329f-4aea-9fa0-c84262713cc4', '220_Maker01', 'Aynalem Bogale Tefera', '0917092933', '220', 'HAWASSA MENAHERYA BRANCH', 'MAKER',
  decode('736dbcdbd448041f2b15de0c6254bf44a5251c9bd981e28239210557e92a6326', 'hex'), decode('f483281a25fcd845764b337022823d71', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '583ba673-002e-4815-86d1-164474a553a2', '220_Checker01', 'Habramu Chane Chekol', '0918535160', '220', 'HAWASSA MENAHERYA BRANCH', 'CHECKER',
  decode('8f846b522b69669160509115330fd780553d483582d588104d0a0f53e8f5348e', 'hex'), decode('c61ac012d619512bf5910ae791cbb44e', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '31d1644f-3013-44d9-b26d-89e22c2f1d3b', '221_Maker01', 'Hiwot Girma Fikre', '0925593998', '221', 'MODJO BRANCH', 'MAKER',
  decode('fc3052f89da911b1eacc762b7c74ebf6830b9e174b9579c544ff0dff6c9b72f7', 'hex'), decode('250b372c59a76c02d477e636fee2bf34', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'dbd087a0-ef67-4541-a203-81cd4f8ce689', '221_Checker01', 'Negassa Ware Robe', '0918696400', '221', 'MODJO BRANCH', 'CHECKER',
  decode('3a094ce980e476ce814b9b2f2d2726b88fec791d9fd039ece1e80c867d6740c2', 'hex'), decode('df60c769a4022fa159c3349786824b53', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8dbfdbe1-849a-4ce1-8c06-3fa77d22cca7', '223_Maker01', 'Mengistu Chote Tofu', '0965787133', '223', 'TARCHA  BRANCH', 'MAKER',
  decode('d3bd98ba01521ce4b87547abd65cafb27adc17af118dd5a912bf8122cfc15865', 'hex'), decode('4c9a7abcefff81f8a0f7a11b5819dcee', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8d4533f7-70f9-4cbf-b677-cd74a0c968b6', '223_Checker01', 'Wubalem Temesgen Belayneh', '0916558045', '223', 'TARCHA  BRANCH', 'CHECKER',
  decode('5a828f2cbbf92128571231679fcc003e63f66dc38e651433d2308717f71af4cf', 'hex'), decode('82d7e0774315344737719e6921f9edd2', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b2bcefea-0f47-4cf7-a791-15532337e65a', '224_Maker01', 'Tadele Tesfaye Teka', '0937656313', '224', 'BONGA BRANCH', 'MAKER',
  decode('09a4ba2092459203bdf6c07953eb127bf45478c49b125c9899952f61908b39a1', 'hex'), decode('aa808c452366345ba6550b90d2f13ca0', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '392d2c5d-fa04-48ad-ab9a-7bee389cf3cc', '224_Checker01', 'Meaza Melake Abera', '0948623928', '224', 'BONGA BRANCH', 'CHECKER',
  decode('c7250073fc2b9ba9f7876a7172d19043a61dec07d752df56a9498341041b498c', 'hex'), decode('cafc193bc3debce8f93599dd89156868', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5d35594e-00d7-432a-96f9-2b53eee3958f', '225_Maker01', 'Tolasa Getachew', '0919144092', '225', 'METU BRANCH', 'MAKER',
  decode('93b8ad0a79239168592801e720b2c477f14f1ff6c32d623c9b6815722824e0c9', 'hex'), decode('dbbf54c47bd0ca97f9928bdf19c94059', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '51f80329-b72f-4b81-aaa0-035d27280803', '225_Checker01', 'Metasebia Kassaye', '0910789438', '225', 'METU BRANCH', 'CHECKER',
  decode('443604714690d5fe9743d52bc396a0eae742d1ec4c6b3a36979a35df733a0dc8', 'hex'), decode('102ffbb7505fd10b9dbfe350bde56ecd', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '6a931f95-69b2-4115-80ed-67743896e484', '226_Maker01', 'Habtamu Teshome Kao', '0926207242', '226', 'HALABA KULITO BRANCH', 'MAKER',
  decode('0b3cc00fd64babd23e2c24d11114e479988b57b5a582cb1abf92f64029ef5eea', 'hex'), decode('1687948dc284763e44953fcb04753c6a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '13d5b567-22ce-45a4-a68e-ab36dce4d3b5', '226_Checker01', 'Degefe Wolde Choramo', '0928970673', '226', 'HALABA KULITO BRANCH', 'CHECKER',
  decode('c02049063969bd2a40fb58ac9bcd1b4a079d1e6d28aeeb64c5f01b91487b00c5', 'hex'), decode('aee0089fa6ddbc5c69ce16b50af39bc0', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a2fa6b9e-5308-48d9-8f1f-6b12e272ba45', '227_Maker01', 'Retta Abayneh', '0937221811', '227', 'NARAMO BRANCH', 'MAKER',
  decode('77d0fa8f97366ed8e8262d1407c8afb5e42a3b0d1e437bf42a71ef75adfc0325', 'hex'), decode('b1c771c4f0ebba16d57ddc4289580ce1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5a33978a-3b4a-483b-b43b-78b6de93854e', '227_Checker01', 'Teshale Assefa', '0916606044', '227', 'NARAMO BRANCH', 'CHECKER',
  decode('c0603cd726131f3667200d726868288121756a00cc2d838152a083e73d976794', 'hex'), decode('554717b9afd7e18893ef16627100b4f4', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a59e46cd-f7c4-4607-82a9-d611fe416a16', '228_Maker01', 'Natnael Tumdolo Habte', '0926991964', '228', 'HOSSAENA ARADA BRANCH', 'MAKER',
  decode('0f6ab785fb444d4347dc332e86c8051e8d4fc8a73da98c1e63d84fedbb2e0c58', 'hex'), decode('8710b48259a9efcf308768ff89fcf9c6', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8779b7cd-aec0-4a64-8405-467e889fb386', '228_Checker01', 'Berhanu Samuel Ermias', '0926486870', '228', 'HOSSAENA ARADA BRANCH', 'CHECKER',
  decode('7b006e31f33f78cbc1b8a5602e43c8fc6e46670a16bdcfbe15312c001f1b27f8', 'hex'), decode('dd388227304d4e0fbcdf4673fd421978', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '51f1a9db-a3e0-410f-8ad6-59210a9c52a9', '229_Maker01', 'Selamawit Achiso Mekiso', '0937322452', '229', 'SHINSHICHO BRANCH', 'MAKER',
  decode('febda5fd261b12a6d960eee8a012087e938e79eea6194f06330562bdaf132e12', 'hex'), decode('0fde8e1321201a22cfd17f52926d30ce', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b057d7cb-1864-49ca-9728-152a35f23bf8', '229_Checker01', 'Milkias Kuche Goa', '0913951146', '229', 'SHINSHICHO BRANCH', 'CHECKER',
  decode('163081e9b61d50d0c45caa3273e4921d276bab7ac14adef3e9b41c492ff7dbb5', 'hex'), decode('916e36f5efc21b5b36f748f7c2d25afc', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b671acb7-8c24-4e1a-9a23-e36bc6bfd785', '230_Maker01', 'Yohanis Shuna Jarso', '0925952748', '230', 'BULE HORA BRANCH', 'MAKER',
  decode('ab7c8c813cb3c8545414705582e4ffeff8c48753a4ca4176f11db162c76d8893', 'hex'), decode('e35777221893e45b4850da458bfb4274', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '86aab9c9-0d93-432c-9348-b248d9649254', '230_Checker01', 'Ararso Bedaso Gumi', '0937078721', '230', 'BULE HORA BRANCH', 'CHECKER',
  decode('bc9ce33b3edb0b23706decb6fbc84953cc9911d45a3f93fd0ea7dee097c33812', 'hex'), decode('d6dcbf46287ebd42e919d066781dfc28', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '974608d7-f4c2-4040-950c-cd4f7f873295', '302_Maker01', 'Firinsawak Dida Guta', '0942995162', '302', 'DEMBELA BRANCH', 'MAKER',
  decode('5b10f137464699cd1dc30a777d8e9ba280e73a23c3ffb320d0c63e60f491c857', 'hex'), decode('89ec08924383611fa2d6c8dc16e1bb8f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'fbe356f5-6843-453a-885a-4dd8c45b371b', '302_Checker01', 'Emebet Tola Gemeda', '0912234649', '302', 'DEMBELA BRANCH', 'CHECKER',
  decode('d9f1bdb56c35826816e88b731b5a7fd7ae7bea694b4e3d1f098638a46cffad61', 'hex'), decode('41cf99171e4b1b7f594abd7ea9710cbe', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '37066591-2940-4559-b328-535210783825', '303_Maker01', 'Tenbite Daniel Abreha', '0915732037', '303', 'DIRE DAWA BRANCH', 'MAKER',
  decode('124722878f99d7d713de6c690e82c8e281118c4acb49140465d3f48fa2938a6f', 'hex'), decode('48501d72c8f6d18468cd5edd36853d33', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '71dfe5af-3152-4ac5-b53a-5c8858f897a3', '303_Checker01', 'Tadiyos Fikre Kassaye', '0947836345', '303', 'DIRE DAWA BRANCH', 'CHECKER',
  decode('298b7defa742b2d2bc189dbab9dcfa424fd123cc37d0150566a9988fcd35ffaa', 'hex'), decode('d54e41198a502deed8fe086c5abd189e', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '264b6f17-7b87-4d3b-ada0-465a2cb21efc', '307_Maker01', 'Dula Adem', '0942101477', '307', 'BOSET BRANCH', 'MAKER',
  decode('51a95953f2668cad162774101fb7cab3b17747c75d3236acacb0f7ac1c14f50b', 'hex'), decode('99a7c44fe3df561c6efb93533fe70cbc', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '00a21f13-f35f-408a-9984-04daf9d77309', '307_Checker01', 'FEKADU KUSHA ESHETE', '0969378884', '307', 'BOSET BRANCH', 'CHECKER',
  decode('fcbda25c6175c02464cbb15f9a60d010a43c66daba7faada75dde1ebf4b5b347', 'hex'), decode('5f1757fe84174bea81f55c535f401dc9', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c6278b28-68b9-4567-b561-ed6f6c382ad1', '308_Maker01', 'SHIMELIS GERBABA IDOSA', '0926904710', '308', 'DEDECHA ARARA BRANCH', 'MAKER',
  decode('a28f0d271d4b1ea411902484d760103fd39f48377d421f412f27ec79ae18685f', 'hex'), decode('9633fcab5fa247719d46c84aa738c6dd', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '2c261285-cd0d-4c4c-893c-e07d2deeac21', '308_Checker01', 'SINTAYEHU TADESSE KEBEDE', '0991330567', '308', 'DEDECHA ARARA BRANCH', 'CHECKER',
  decode('cce74dcc97b273973bebb71c73dec24835a81d5ff225bb95218fb0a4e5951e21', 'hex'), decode('40f3b43f1cb76d8ac0db35ec67157f1a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c57c95a2-fa3a-4f90-a2cd-51e7f256a076', '309_Maker01', 'Alem Kebede', '0961964987', '309', 'BATU BRANCH', 'MAKER',
  decode('e6a458ae60ad7b49fcbeb34bc4a6cb45641c89a2667bcd122e6c6b377fbd79df', 'hex'), decode('e39b4590820a4e68ad126fe0cdb4e165', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '04f7f44d-eb0d-49c8-b1d7-4e7a099157ab', '309_Checker01', 'Gershon Gitore', '0920523909', '309', 'BATU BRANCH', 'CHECKER',
  decode('c31d4e1c84c48b334bbd9f16a71551a94e5f38676997059f118d2fd7a0a669c9', 'hex'), decode('89ae181777245759afbd83d5f028be43', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '2751682e-034f-4f07-920d-fed2025e8d70', '311_Maker01', 'Yohannes Tesfaye Amedie', '0920761039', '311', 'SEMERA BRANCH', 'MAKER',
  decode('eb1811ca5c067024eb9417087f5fc82aa9cbbca154431eafb736d1949a1b60a8', 'hex'), decode('5e30ac74f6982a6358189946ae6565c1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '08c7a424-1f6a-4dfa-be2a-dea0550a4d9c', '311_Checker01', 'Solomon Anjet Tibeb', '0924274543', '311', 'SEMERA BRANCH', 'CHECKER',
  decode('b4b9c9e6e01446e18ef3bd1118d15922da6d7fe05911969be491e8963a0afe8b', 'hex'), decode('328f7669cf3527e52e49331fee31a0f9', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0031238f-3af1-40c3-81bf-75716ed9add7', '312_Maker01', 'Gemechis Tadesse', '0910677990', '312', 'SEBETA BRANCH', 'MAKER',
  decode('89ebd579cd8caa25d8da655c79f857eee559cabdb9d8d17859aae723ae838da6', 'hex'), decode('ba6f8e780d9bddab1375642d96c8e27d', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '31ccad1b-9f8a-4f08-a1c2-88399be937da', '312_Checker01', 'Firew Gashaw', '0932488883', '312', 'SEBETA BRANCH', 'CHECKER',
  decode('e78516733482fb8a7493e4d22a4a0edf8a56f2523948cbbdca2da8fb55856f8b', 'hex'), decode('9ad9c5eb6b2a71a3850a8d066ee65754', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '7bd86d18-885a-4d70-8616-030589a14945', '313_Maker01', 'Megertu Deme Asaminew', '0954707992', '313', 'BALE ROBE BRANCH', 'MAKER',
  decode('9402684eac5614527218de3834fbd9a8a0909aac9c9a1ec7cdf15432c504793c', 'hex'), decode('7e04bea18c9c2599e4313f92c1b43b9a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e97b0bb5-e52d-45a4-a3e6-acfb84fa73bb', '313_Checker01', 'Eyerus Bahiru Motuma', '0931422987', '313', 'BALE ROBE BRANCH', 'CHECKER',
  decode('fa26e8243ee3706f64b90b54d692cdebf459167b25f3fc630b60b87510d98902', 'hex'), decode('9425ff94826f2f2bd29d2dd88122eac9', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9cdb56bf-f1b7-4a61-90b5-28520f659eef', '314_Maker01', 'Teferi Tsega Ayane', '0943102124', '314', 'ASSELA BRANCH', 'MAKER',
  decode('c41dd117d61186bdea45d885412ec532ad35119ae0a1b72370e507fc589c8067', 'hex'), decode('66dcd6a853322ba0c5fb425ec70f0e5c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5deb8f5f-812f-4788-a3b8-ecf5809ebb8a', '314_Checker01', 'Derese Negash Tefera', '0922304093', '314', 'ASSELA BRANCH', 'CHECKER',
  decode('1c4351ec0303df93f1b074427415d1c464f12a023ffb53e741e4988dc5a118d7', 'hex'), decode('119b661fc16ec055dd4dcd44d00c8702', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '16dd62e9-05fb-4c27-a941-bf8b5f06ab80', '315_Maker01', 'Betelhem Yeshanew Azene', '0922062906', '315', 'ADAMA MEBRAT HAYIL BRANCH', 'MAKER',
  decode('6c3eea432c47cacb39c6074b1204ca343a2b0de6cf799d5eb05a60be35b16079', 'hex'), decode('44c7d2f2b2089a2739cf309821ba93f1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '777c2676-2a0a-46fb-9310-2bc970d088f1', '315_Checker01', 'Ashine Tefera Woldeamanuel', '0968258117', '315', 'ADAMA MEBRAT HAYIL BRANCH', 'CHECKER',
  decode('9bdfdaab2ac2c1b0d20decea14c68ad1ec95b0ba9c82f4b207fe33a108853a79', 'hex'), decode('8a4a4f7814c96a449d23ca7fe90fee01', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '41b9857b-ee3e-461c-a3cf-56d7cc6e848c', '401_Maker01', 'Mesfin Yazie Sharew', '0912658932', '401', 'WOLKITE BRANCH', 'MAKER',
  decode('0eade871a32d5fd53419f34035953ba7d3792a4c1bd29326cfed3f2f24a19df3', 'hex'), decode('a2d8bbe6adc5714017d55c3b83f1ef71', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd9109fb1-6dae-4d94-a1a9-747084a615f1', '401_Checker01', 'Jeyerusalem Girma Kersima', '0910452811', '401', 'WOLKITE BRANCH', 'CHECKER',
  decode('b574d67b7599019dfa4d1791a661438d794d073a8dc5ac574fb77ac80ce13840', 'hex'), decode('015e4c3c63fb7520b375ba34a6aa3395', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '2b0538f2-a3f2-42be-9c76-14c33dd0d635', '402_Maker01', 'Wondu Teshome Dilgasa', '0913591210', '402', 'ALEMGENA BRANCH', 'MAKER',
  decode('36a9e7d4e4b4b71de2e73e8795d8cc488852c96a70dc386fc1fc3a0614f443ac', 'hex'), decode('d57cd006f99a93957a49029f09a904b2', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '418d373f-9e4a-416f-96ac-0e350e2a59a4', '402_Checker01', 'Temesgen Asefa Shibiru', '0919554887', '402', 'ALEMGENA BRANCH', 'CHECKER',
  decode('23cd23cbc802df2bd0f77ac75222dc2a313ce9564e8cf285a0eaa4d183252081', 'hex'), decode('e378d12848af82a7c24ddcd071fe561c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1e75e637-5bfc-4467-b22b-02d84cdfcf6d', '403_Maker01', 'Rahel Otoro Kebede', '0979053661', '403', 'JIMMA BRANCH', 'MAKER',
  decode('111e141fc35527c13fa67368caa45931321d79e1a2a3ef5a15fba2a804fe46fc', 'hex'), decode('bfe8a932e3fb915a5360d7611bde5dae', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5de62867-e244-456d-910c-6b39c92721db', '403_Checker01', 'Tadesse Asefa Ayele', '0920221780', '403', 'JIMMA BRANCH', 'CHECKER',
  decode('8f0a14ed740337377d5a4f4fb5f3814c9fef50981d07007dce372687c7d87e57', 'hex'), decode('8cf4108996674287377150198a2952fb', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9d656021-e341-461f-bd10-067a036cff9a', '404_Maker01', 'Busa Tasisa Kalibessa', '0938340651', '404', 'BURAYU BRANCH', 'MAKER',
  decode('236e32b8af917dd806126b3591dd8c7de5f46184a7aa08c2b4fb4caf55623a69', 'hex'), decode('12b0c4821f8b683d3484aec4e564e4bc', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'cf60d3f4-df16-4e09-b581-4f4031200d56', '404_Checker01', 'Yabsira Abebe Getu', '0923853040', '404', 'BURAYU BRANCH', 'CHECKER',
  decode('d202bc2d10a6d54c1c7cab553898cc60f2f379d44edb6a56cec1a00e7acc6b46', 'hex'), decode('45218273c45cc2594b8470ad830b1394', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'ed082557-132b-47ae-96a7-5cb334b1e56c', '406_Maker01', 'Wondimu Tekito Mesfin', '0943148582', '406', 'MIZAN BRANCH', 'MAKER',
  decode('6ac2bdaa0f479f162450deccc0f0528a39b3fec355859b9c2f24f4bc587b364b', 'hex'), decode('76a52a730cc249a5e648203d5aea4363', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c71a99c7-85de-458d-a906-2ac3357744fd', '406_Checker01', 'Meseret Zinabu Niguse', '0900256503', '406', 'MIZAN BRANCH', 'CHECKER',
  decode('293c4ad2745203f777022d66a3a7a943b4d673784026d1ad6fd441e453f8990c', 'hex'), decode('21d5523e2ef3b5b0055e51d95fdbffea', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'df5fdbfa-0ae7-446f-88da-0e6f4246cb2b', '407_Maker01', 'Mitiku Wakwoya Chalenka', '0945950814', '407', 'WOLLETE BRANCH', 'MAKER',
  decode('46e65c241ede75351e33130d1bc483fb1551a10df491ede38c82a8e2de63d609', 'hex'), decode('01791647dac1b522c1ec03dddb1e70e7', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '7c366bae-ff16-41ed-ad6b-3155c03a84e9', '407_Checker01', 'Amenu Dereje Mekonnen', '0935883777', '407', 'WOLLETE BRANCH', 'CHECKER',
  decode('fadc087f51b55fe068ea8bbc89c7de3efd65853449799289f628871581381535', 'hex'), decode('302740cb0db8d16984655ff133ce0082', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '2b5633b2-f137-47fb-acdc-3c27df87075f', '408_Maker01', 'Tsehay Negese Tola', '0917441355', '408', 'ASHEWA MEDA BRANCH', 'MAKER',
  decode('a59da3a087a85451165623607a2a8a4e1ede03633cc439f85799908833f01797', 'hex'), decode('70f023b1211372346fef79a0a7c76a25', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '646ca4b6-42af-4982-822f-afb1bdd4379c', '408_Checker01', 'Jemere Abdisa Teferi', '0921574751', '408', 'ASHEWA MEDA BRANCH', 'CHECKER',
  decode('d096c17ed60621ab642bfa58dfc87bfc77c08865f5825e7c5641d34ff4bd9c39', 'hex'), decode('d7d8f602a0a85d1c73520bb07b4212d8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '7fcd18b1-43eb-46af-b033-c84856cf0439', '409_Maker01', 'Demissie Alemayehu Kassaw', '0924357002', '409', 'GAMBELLA BRANCH', 'MAKER',
  decode('58c6bf3795b5cd71f2fe7a6c8604083a6b46f3e87660fa36c9efdcf06e389878', 'hex'), decode('99d956ca94d05f30d3dbd26dbf12ba56', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'cc338b5a-ee9e-45d8-b761-75aa930d7e03', '409_Checker01', 'Mekonnen Bizuneh Kassa', '0912921187', '409', 'GAMBELLA BRANCH', 'CHECKER',
  decode('a557884464fdaa1bbedb19e84075c15cdc3511b2315c27cd62449bc28b1bb0f3', 'hex'), decode('39bb277f42ff571be89f7893beaa8ded', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8855ae81-1c4e-420a-83be-e34c3931cc1e', '410_Maker01', 'Amsalu Endale', '0940006801', '410', 'AGARO BRANCH', 'MAKER',
  decode('7e74b6feca2c7bfe81622960e62e9d99e597beea28a47b7f8d5aebf1b15115bb', 'hex'), decode('ec0a4b51f42d014380c152f92c6a0646', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'efe51ac1-1efa-4d7e-a958-24a0d10d5406', '410_Checker01', 'Kenate Hailu', '0925930811', '410', 'AGARO BRANCH', 'CHECKER',
  decode('a2a490232b105063304c515d6160c0d5415afcc63d9167b560585036f88a3275', 'hex'), decode('5875c1fe57ffe446b50840693bda13c8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '26d0b0fc-d203-4edf-91bb-b655ed3ecae9', '411_Maker01', 'Mulugeta Chala Hunduma', '0913388477', '411', 'AMBO BRANCH', 'MAKER',
  decode('ddcf304b6095887470fc97f487a0db9a4e28738cac8b24304ab9e99bfd4c78d6', 'hex'), decode('4d77e12d5daf01247898c0b947a7e463', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '14d49af8-fe07-428d-b984-b3632015f97f', '411_Checker01', 'Ayantu Abera Gudeta', '0917707770', '411', 'AMBO BRANCH', 'CHECKER',
  decode('af6b545269ff3df116176eeda26b14190d242649263c15ffdb53e3063a26e135', 'hex'), decode('25a85b17068fdb07a383fb639035823b', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a4e1c0d0-7523-410b-a215-8cdf928794ca', '501_Maker01', 'Betelhem Gebrehiwot Meresa', '0914704699', '501', 'MEKELE BRANCH', 'MAKER',
  decode('d39b0c03a24e9e2af6f39d2b4f339152cf345132980ee6a057c31f61827c0396', 'hex'), decode('75e1771abd4e55c838396590b2c3df64', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c66f4716-9665-4c8a-8623-d0d091a47a4d', '501_Checker01', 'Haileslassie Mekonen Haile', '0986898130', '501', 'MEKELE BRANCH', 'CHECKER',
  decode('995c4ebc056078eaacabc0a45b63ee71e032ac66b33ea0e7b809e8e5290a7d7f', 'hex'), decode('16a4d95a2576a75332ffffccb5a6d7df', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9a9a47f0-7ffb-4c6d-a327-0706c2e827d2', '502_Maker01', 'Esubalew Muluye Yitayih', '0945436614', '502', 'GONDER BRANCH', 'MAKER',
  decode('5474e1be2279b34a10543200e32d56cb1eda1390475e3fa3f992e8e449c1265d', 'hex'), decode('ae3bdd8c5f889c2ff7a49e7a251f2468', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '50e87d77-d060-4ec4-ad1e-0a676a96546e', '502_Checker01', 'Ayichew Walelegn Yigzaw', '0910746373', '502', 'GONDER BRANCH', 'CHECKER',
  decode('23cfae944483c14705fd7fabd1c47eee002bf9573bd853cb7ce5dff96dd7c902', 'hex'), decode('9f29bfac5110373cd237873bc258f2b6', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f657f4cf-6e43-4f16-87b8-9fa774f7f0f3', '503_Maker01', 'Tarikua Kebede Miskir', '0937406218', '503', 'BAHIR DAR BRANCH', 'MAKER',
  decode('d4ed9985165138e95fee39f11dedf5387dc4a0d1a3fab690a9a3dd9c3f7f95f1', 'hex'), decode('bef809819c5b6c91b67fd7bdbc87db7d', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e0895954-188f-4297-a634-6570d097b3e6', '503_Checker01', 'Tekabe Amare Zeru', '0911542095', '503', 'BAHIR DAR BRANCH', 'CHECKER',
  decode('edef09b014487f04e88ad4fb40cf7947cee1c0d0e8ddfd196635454bc7dfe21c', 'hex'), decode('b514cbac90193e86dbdffb0ff1c6de3d', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '758e1d9b-3d04-4212-8ac6-521a3442b6b5', '504_Maker01', 'Alula Girmay Radae', '0968928658', '504', 'ADI HAKI BRANCH', 'MAKER',
  decode('5fec6fdbdbb5634412e5abe4ba2ddf41728d5d85b4b440d8cc9cbf34e0b5aebc', 'hex'), decode('312838027f871b4913ad7ae7a041d335', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '222fc9b6-03df-4e70-90b7-20e3f9e9db2a', '504_Checker01', 'Robel Gebrehawaria Reda', '0948515244', '504', 'ADI HAKI BRANCH', 'CHECKER',
  decode('cabc3656f520a378000f3fcc14185b59f53a72693905e680b609b8b062c20a5e', 'hex'), decode('63417e144f1ebdfb593803a33f2af2b1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8438b237-cb4a-4dea-826a-5df73b0daf77', '505_Maker01', 'Mehamed Ali Abdurahiman', '0933083028', '505', 'HUMERA BRANCH', 'MAKER',
  decode('4151739c5a5dd826315b5406b78a9a8fb5c5ae0e6558da50963b1d1fb177beb9', 'hex'), decode('3ba35c59b668a194d52fb891f03b773b', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd3c91c3c-5622-4e5d-80b0-be451bc3070f', '505_Checker01', 'Mengistu Angaw Adugna', '0953244255', '505', 'HUMERA BRANCH', 'CHECKER',
  decode('61d55407cbb620d8eedc6daa8476cda31066d2c2e9d6aba6270952f7f10e40dc', 'hex'), decode('56ef06df5bcb94fcc694ad2304c44230', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '62056174-5f55-4aba-859b-3674a2e39e72', '506_Maker01', 'Kifle Demeke Diressie', '0930608749', '506', 'DEBREBIRHAN BRANCH', 'MAKER',
  decode('53480f842b80321cdedc6b22a31cb9b234a262f0067f80d0713d8d23ba1d869c', 'hex'), decode('a722952288a235bc6389040eb0fa7d75', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '4f465d57-37a8-4b78-9b43-6aa7cedb2ff7', '506_Checker01', 'Zemach Kebede', '0928756415', '506', 'DEBREBIRHAN BRANCH', 'CHECKER',
  decode('864d082bb52e6aad32c12d263fc9cc551c86aed2e7f1f575cf038395c49cd179', 'hex'), decode('72fb4e2d64149113502673145b1d0079', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '81d5c497-6876-4f0e-b89d-33af0dfa0c46', '508_Maker01', 'Meseret Taye Niguse', '0946671128', '508', 'FICHE BRANCH', 'MAKER',
  decode('ee8fbe58803d2b4a5ef7ac25be1003ac25837cd5516cae1fe75db19c8498bebf', 'hex'), decode('5025217347d8c816af030647f2753d85', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '143b2dd8-c1a2-438d-bc0c-2e9beafe698f', '508_Checker01', 'Nigusu Mekonnen Bayu', '0910724718', '508', 'FICHE BRANCH', 'CHECKER',
  decode('9c4f9911d1d577574eb6ad34566dd4b3c8d2fb3483fc4b064052839abd02a716', 'hex'), decode('658316165f2331850c34ad967f239924', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f6045e62-3699-43fd-b94a-2bd9fdb0dc78', '509_Maker01', 'Yirga Alemnew Tesfaye', '0920774186', '509', 'MARAKI BRANCH', 'MAKER',
  decode('38018248c3841d46343897d0afd369382e967df137c319936030d9ddc399f4ec', 'hex'), decode('d7a8ccf0492598fc555c47e2108916ce', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'dbd84a81-f1b3-425e-be67-ad77c0d4a4fe', '509_Checker01', 'Amare Yehualaw Fentaye', '0913547101', '509', 'MARAKI BRANCH', 'CHECKER',
  decode('502af6348bd13985d35fe0dd4abe990dfa5433784a95135b4468a08621621bcf', 'hex'), decode('82677d42e6f568703ed7ab3fdf99c4fa', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9886a5fb-666b-4db9-b3d7-6ca5558ef189', '510_Maker01', 'Tesfaye Gizie Endeshaw', '0921814466', '510', 'GISH ABAY BRANCH', 'MAKER',
  decode('6c4fb951faf6dd922d8569879627403585df4d9929dc298fce95792e43447c99', 'hex'), decode('254bc4c74856e5313806ef512c6e15c8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b0088686-909c-406d-ab87-911ba8b49d3e', '510_Checker01', 'Samuel Abebaw Tadesse', '0906928377', '510', 'GISH ABAY BRANCH', 'CHECKER',
  decode('576bab7e5649ccdc617c7d338fb96aa90cd82f8ffc6aa56d6bdf0fcc8aba1485', 'hex'), decode('eb362a383c7ec9cef0a2b9b0a7043035', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1021fd6b-0d13-4b08-92b5-6aecc706bc04', '511_Maker01', 'Endalu Gelalcha Gemechu', '0919902129', '511', 'SULULTA BRANCH', 'MAKER',
  decode('90c476da8cee06a6d8cf6d814bafcc125efbbe74e2b57b93c896e4e89d42a3f1', 'hex'), decode('805aa1418514043fc7a1fb5bf5deaff8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e93121f9-2dea-4c30-872d-69005454f430', '511_Checker01', 'Sisay Kafalew Tita', '0943286174', '511', 'SULULTA BRANCH', 'CHECKER',
  decode('dd82e629e2d514f7d19bcc5f25b3532778074eeda8c20ee7b71f6c035a088fc1', 'hex'), decode('a3fed79eb958c9b8ad04bb26958bf065', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a58cf698-04ae-4abc-b516-f1effda371e5', '195_Maker01', 'Elsabet Shiferaw', '0901733239', '195', 'TULU DIMTU ADEBABAY', 'MAKER',
  decode('a977e2c323fe8f338e654cccd56adace460a51ef466e475258e3cc04f8730d2f', 'hex'), decode('56a4e8f2c2dfd9c4bbd9ecf9365e75f5', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '23f1bb33-3e71-487c-b343-92120d372ecb', '195_Checker01', 'Saba Jemal Tadesse', '0911884180', '195', 'TULU DIMTU ADEBABAY', 'CHECKER',
  decode('c88454e114bfc14d4c6f0f659ba106bf16a65da7fed0e2ecee5f8fce58cac263', 'hex'), decode('fee9addb1bd8cb5fb75843b5c9ade778', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'ba84fe7d-0c64-4668-a82c-114d650ac959', '196_Maker01', 'Walelegn Adugnaw Tilahun', '0921580188', '196', 'GORO GEBRIEL', 'MAKER',
  decode('a6cbc359cbb4e7a231c9bd5ba36fddd90188df91d9ed42fb28e2b87692b52a65', 'hex'), decode('f165a79f4d89b99c57506c5042913eea', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '17ac2d62-b2ab-4b3d-91be-10e62c017b49', '196_Checker01', 'Aster Moges', '0917307350', '196', 'GORO GEBRIEL', 'CHECKER',
  decode('19b892cfba9e3d48bc82ed7fd62f585ada6003f1e47dfd8b633c8db8108550ce', 'hex'), decode('7256d689cf8a82503d4c78f192496905', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b6e9ee04-18e9-400b-bdff-fb515686a469', '412_Maker01', 'Milkesa Negassa', '0913391223', '412', 'KETTA BRANCH', 'MAKER',
  decode('27020056510d0757ab45666f756850d0c0e663cde1ca58514167e707f1894a50', 'hex'), decode('8148ef4ef7215335821c4ea25e977a3b', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '603b1120-7827-4d51-a7f5-ceff909611cf', '412_Checker01', 'Tigist Seifu', '0957097367', '412', 'KETTA BRANCH', 'CHECKER',
  decode('c8d24d0c91d65e8d3df4c47f4690de153c5a5f176efe774dc58dde483f90996e', 'hex'), decode('9424c0a2cf72be878a2fef1b5bc25cb5', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a0c405d8-024c-4090-8333-af0f87cd104c', '619_Maker01', 'Amanuel Alemu Atomsa', '0925455730', '619', 'Wechecha Branch', 'MAKER',
  decode('f6976659d36c4b734256d83b3684c49f6c0d84bb4dfc49fbca1ad6f0594ace93', 'hex'), decode('f68fababd6141489116a6e7537dff6f5', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b962a7cf-0ce5-4bd3-ae1e-11a666f6014c', '619_Checker01', 'Sena Fitesa Guluma', '0941078138', '619', 'Wechecha Branch', 'CHECKER',
  decode('467851c4098e76141c6ef1e22b82c36e65ca06abf8d1523868ecb48e3d85cd18', 'hex'), decode('a12c400dac0b6734cae7a363c8975f01', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '4e867ec8-4808-4235-be50-01a226437797', '321_Maker01', 'Jirenya Negero Tadesse', '0917117908', '321', 'HASASA', 'MAKER',
  decode('49455d712f345be6abb4388cba12abd4c4dd6c31aca013d20f9e3ea1049d87b0', 'hex'), decode('042a83641a0d108f4c16d12c45b05f06', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '70e1a0d5-ca59-4cb9-9c8f-3023d954e019', '321_Checker01', 'Zenach Kura Atnafu', '0916381274', '321', 'HASASA', 'CHECKER',
  decode('80bdc7f730d51d4c22a5a9469a3b44fbbfd255464dafa016024e52f157d1bb9e', 'hex'), decode('faea155ad27eca33fae6c7feb21d0f2e', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9240a4c4-96f7-471a-8928-384bd61a7e18', '328_Maker01', 'Mekonnen Debebe Hailu', '0951982733', '328', 'ADAMA SEKEKELO', 'MAKER',
  decode('794c81a262dd7a20cc13adbc137fccdf3b35ffdcfc753c1a3154a1e5faabf112', 'hex'), decode('496cd08d9da9edfd8072008397d782a2', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5c172121-d5f0-4e3d-ab58-7dec089f66b1', '328_Checker01', 'Asnake Sileshi Bekele', '0928039718', '328', 'ADAMA SEKEKELO', 'CHECKER',
  decode('e98513e823ede427f92a544d11efb436ea77c4fc0884bb672c496c567fd60259', 'hex'), decode('a417555647b6d5a5b31ecd964e4ec35e', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f119a87b-0e21-46db-b8ba-8258b9640984', '234_Maker01', 'Bethelihem Siyum Tefera', '0978848246', '234', 'NEGELE ARSI', 'MAKER',
  decode('f01ffb5cdaf0c7dce29cc862b92f7c1acecd249acb78dbe4f12428a82143a61b', 'hex'), decode('f337b3797bbf07bd4b68e2617cba4f4a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '68c22132-6eef-42ac-980f-e358c2064dbe', '234_Checker01', 'Beamlak Alemayehu Balcha', '0916789049', '234', 'NEGELE ARSI', 'CHECKER',
  decode('52fc3ea6d2f9c8bf0a9a4c6d41090724605480c8a5a1ac17a681fbfcb46cac7e', 'hex'), decode('6b3329a79bc18bbab5d39c0df0bd41f1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '25001be8-0aaa-43c6-b9fc-b21169b28bde', '330_Maker01', 'Gadisa Guta Dabi', '0927960530', '330', 'LUGO', 'MAKER',
  decode('d7a890722bc04d03d785569616bebd728cd4f04ce3e70fda8a59a6ba7213ad6e', 'hex'), decode('8c42409339f79beb4245e7d48df5c5d8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'aa74d58c-b2c9-4ccf-ad6d-b99ea9ed8f0f', '330_Checker01', 'Lalise Asefa Regassa', '0910102631', '330', 'LUGO', 'CHECKER',
  decode('d0cb58c08b4759a7cfd1e79880eb3bbbc6e17edf5b3c4f44ad962ad8ac8aaa0f', 'hex'), decode('5b78790f88af292e6cd22752b097f6a8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'dbb0b32e-cae0-4d7f-8a57-3cd86b6caeda', '329_Maker01', 'Nibret Sisay Asnake', '0904442860', '329', 'ADAMA PICKOK', 'MAKER',
  decode('57450a579af51d3ac214f4d8e982c8b5099690d0d416a59b39b7b0f8a5bf8443', 'hex'), decode('c79ef05891944fae3deab8c60a0f6389', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9868b57b-4967-4058-ae58-aa352422e4b0', '329_Checker01', 'Birhanu Abebe Shumi', '0923715085', '329', 'ADAMA PICKOK', 'CHECKER',
  decode('531af8e1ead703496c0f2498b8af9bdcd3eb7ba95f810203c1fb01ab51bb51d5', 'hex'), decode('23d653c7f3566f9d19eed73220ed6c46', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '44cdd60d-d647-4741-bdbd-33120c79b24b', '322_Maker01', 'Firehiwot Alemu Degefa', '0912508910', '322', 'Adama Dipo', 'MAKER',
  decode('ce6ceee0d7b628089061d5649ec5771cc953fd51f2fbd26234be987454335c35', 'hex'), decode('38c7eb84723391d3481931828e302485', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3edcf084-ce74-4ff8-a57c-348881494a47', '322_Checker01', 'Tamene Girma Balcha', '0953553421', '322', 'Adama Dipo', 'CHECKER',
  decode('1bb8822a178ebdbf6aa81aa90fee8f8101ca74d084842a9948e63dc6204b6dc9', 'hex'), decode('5988c8c32021b6df2278d557a3d06b90', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1dc88651-ed88-469e-b4ff-587973fa0131', '325_Maker01', 'Zerihun Megersa Dibaba', '0949293439', '325', 'ADAMA PAN AFRIC', 'MAKER',
  decode('23c96af78f97e481da4ae313491c42fbe3572fc3d630337c246645576e99460f', 'hex'), decode('312cec3eb8db28a6568cd3cc0581e9dc', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1387c665-7a6a-4806-9697-48d596dbabf9', '325_Checker01', 'Asrat Bekele Lalego', '0936497665', '325', 'ADAMA PAN AFRIC', 'CHECKER',
  decode('b50c25a1b9a1e91641c65fbb6c8a47702ef8b93785e150b9f1326d57dbf3b208', 'hex'), decode('742780df0d42b23a5ffe82a3324bf274', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '12a97846-d694-448f-b964-640a27b63a2e', '327_Maker01', 'Telila Shalo Telila', '0910252035', '327', 'ADAMA SAR TERA', 'MAKER',
  decode('0ae9e2ecacf63806cf60e5eef306ff0166b2a8de485c123e35400d36e158fa0e', 'hex'), decode('2aa4593ad30d3116910e59ae46c47951', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b5bc8332-295e-4ca3-b017-dd050fa38c17', '327_Checker01', 'Tigist Negalign Ashenafi', '0991355002', '327', 'ADAMA SAR TERA', 'CHECKER',
  decode('10022ce2a44fd96dbc1793303c365da4addfb3dc0adc509ec164e896c7d6edb7', 'hex'), decode('e4a44db5ac366f6cd21996ae9295ea90', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3f132e39-9c37-418d-a78e-9623a9e6414f', '324_Maker01', 'Yohannis Tiyar Gonfa', '0911271588', '324', 'Adama Sole', 'MAKER',
  decode('a415fcf5d8501a0a07aca23449be83996e74db7d2a77f6ba84106b8bc6e1d3a8', 'hex'), decode('c60d6fd735f7e4286ea959ae026d0f13', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5ddd8a66-180d-49ce-8395-4ed440a4bdfb', '324_Checker01', 'Semere Getu Haile', '0903148536', '324', 'Adama Sole', 'CHECKER',
  decode('f848ca84a01ed57e7cf3f064e93c080aeb89d4cf789f639eb123a23de4c44154', 'hex'), decode('4fbbc6d95ddff981e0bb5567725de567', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1e0fbb13-9cc3-497f-ad90-54d1e70fe7b8', '185_Maker01', 'Aregash Aferu Yilma', '0947927738', '185', 'Bole - Dildiy', 'MAKER',
  decode('a7ae3da049402ed3376bd0429ca2f1ba4c236634b0dc0f88bb2e5d2b60b72135', 'hex'), decode('c19dbad5f16515602a4254786f76ff10', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1c1bfeff-a203-470d-b68c-6ed437863ae6', '185_Checker01', 'Roman Tekle', '0911709137', '185', 'Bole - Dildiy', 'CHECKER',
  decode('3034937b93010e0b30d1e3b29b61e9399af8ba3140a84b013c74c9ee35dd53f4', 'hex'), decode('61e073f77c15ff0c0b23540ffb2583de', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '975a5573-41f5-4ef7-8b07-7b0713db37ef', '604_Maker01', 'BALEMLAY NIGUSSIE GELAW', '0940138280', '604', 'Africa Hibret', 'MAKER',
  decode('bacfc53875e69919c51157e8fd976d52c7b672f934f078849a914c456aafafa3', 'hex'), decode('877c09d899833079dc89f754df1d2f7d', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3299913a-74c7-4967-a840-d4ae01cd127f', '604_Checker01', 'BANTIDER ESHETE ALEMU', '0902369877', '604', 'Africa Hibret', 'CHECKER',
  decode('bd6f33920ba3271230d113885f3037f086249140f81bc71c28ff055c7989b221', 'hex'), decode('8d4ad4b42827b0a40499f1e124df2bbf', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '751c8d2c-2859-47aa-9ce1-3f7294a5febb', '415_Maker01', 'Kidane Gidey Agebremedih', '0911271059', '415', 'KELECHA', 'MAKER',
  decode('213b635c900d798b116c423bb33a43ade1ee58e3fb34f3d43795ed11f046b559', 'hex'), decode('3c0f883f18ad40630f23b36f91297534', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '962d8293-3c33-4bb7-ac64-10c0f9d662ba', '415_Checker01', 'Monsen Alemayehu Abera', '0924620497', '415', 'KELECHA', 'CHECKER',
  decode('d9ecdca726257decf873bc79fef87458b03bd22484f1dbe32225f0f77e90b0f2', 'hex'), decode('bcf8d1ec0b5488c5f0a8fad425e5cd25', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a58322cd-9962-4cfd-ad16-f6a9b4f2a13f', '335_Maker01', 'Fieyissa Dida Kebede', '0933446789', '335', 'TATEK INDUSTRY ZONE BRANCH', 'MAKER',
  decode('cbbb1d116486c643909f17568ec990f413a692e101b4ff33e84982228414d018', 'hex'), decode('613cc3de23efc5225a743c7738059d6c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '320bd504-6bb1-4a7d-bedb-e57af734f2e4', '335_Checker01', 'Merartu Asfaw Dame', '0970447901', '335', 'TATEK INDUSTRY ZONE BRANCH', 'CHECKER',
  decode('32ebb37f07fd69d94e89f4c4060fdbfed3d200988e37957cf820b9bd85bb204f', 'hex'), decode('6dfe11899baefed43379cc6bd5aa7108', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '99cd101c-6ade-486a-9add-060d28b15a77', '515_Maker01', 'Hagos Hadush Weldesamuel', '0912652012', '515', 'ADIHA', 'MAKER',
  decode('4d3694e66f9e9dfe33c5e20264dff0785fcc78de65d5d2b77420a13896452407', 'hex'), decode('8d407fde4a27727b620df25d88a8c262', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '21f0f08e-2764-4a5d-889e-89528767691b', '515_Checker01', 'Weldeabzig Gesesew Asgedom', '0919020506', '515', 'ADIHA', 'CHECKER',
  decode('e68d1b6b8c67875a120e159859aec4bc2add6a86929b61bf7f32f00baa826370', 'hex'), decode('28886e34e52f1b996143650c0f285818', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3e45bb10-489a-4a3b-bb26-9f082ce1a5e6', '155_Maker01', 'Meron Mulugeta Workneh', '0962243094', '155', 'BOLE', 'MAKER',
  decode('11a2772a7eddb75e8b8f23b94364697a3ca638c4023d494f529ef7394c920ab2', 'hex'), decode('31364e75fc6d1730de7d6991ee73e573', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e302d961-3de9-4b0b-a4dc-e5178fca2b6e', '155_Checker01', 'Hiwot Gezahegn', '0910281427', '155', 'BOLE', 'CHECKER',
  decode('9aa2f2a8482b9b7946a6bf76feea10fccfdc04701d06b6d46f0b7b6b7f75043e', 'hex'), decode('ab3fe64f767a1f331a4510dde6aa117d', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8517608d-e02c-437a-8cda-614e2e95f580', '413_Maker01', 'Phawulos Tolcha Asefa', '0947552886', '413', 'GEFERSA GUJE', 'MAKER',
  decode('e1c75d209309f08b8aea8ae37107d179358a12c4c150bbc27f6778c722a2bef1', 'hex'), decode('fb8253542496afa407468903bc878350', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '11877469-c860-4ad8-8a86-c97c39affb10', '413_Checker01', 'Hailu Gemeda Hirphesa', '0931702116', '413', 'GEFERSA GUJE', 'CHECKER',
  decode('8121eb7b4c66ab77d208f722ac49519859bf6e47252213f7c5058aa265ca6e8c', 'hex'), decode('1dd2a90f5a1dfc48192b855eacce56ea', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0c9d25e3-4298-4ce6-93ac-174fc9b9190f', '623_Maker01', 'Kenefsh Kechalo', '0955333778', '623', 'SARIS ADDIS SEFER', 'MAKER',
  decode('93663d8dfaaeb9ed328c09e0c2ef5a76c1ea8139ed0708fcdc9448c2fea0fbe5', 'hex'), decode('63bffa7c10753014214c11fda97153a6', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '57bc68a9-392d-4531-a5a3-358f8be7baae', '623_Checker01', 'Kenefsh Kechalo', '0955333778', '623', 'SARIS ADDIS SEFER', 'CHECKER',
  decode('ee319db86812ba5bff8132159fcf4ee2a6fd2368c864c67214ea61d7197ffe08', 'hex'), decode('2894ee1ee14c7c7031be7b02558a068e', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b8546b30-c818-4985-8a5c-d5c3052d903e', '197_Maker01', 'Kinfe Lelissa Balcha', '0944189614', '197', 'AKAKI TOTAL', 'MAKER',
  decode('4d1e701e14dcc197bd8068cbdf06f35439c6f3ad3d28a907da88f863bb25b1d6', 'hex'), decode('5be3f1284cf7e44305fe5f5bbdd1c809', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0f140fc4-be74-4261-bd71-1103e863ecfb', '197_Checker01', 'Rahewa Zerabruk Hailu', '0910160509', '197', 'AKAKI TOTAL', 'CHECKER',
  decode('9589e496aa7e51f8e860a12892f419655a1dfed1cf732531f57d56051bd0a25a', 'hex'), decode('2b800f086d6248cfcefeb641be76783b', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'ae67e559-9443-4003-ab81-2e3acc5f0565', '616_Maker01', 'Wubye Bete Tilahun', '0929085374', '616', 'GERJI MARIAM', 'MAKER',
  decode('9254f6f9de1c134c310fb24e692ac54c04a79d90abc7b1eaa19d6a13e8b83a66', 'hex'), decode('f4ac9ff3359fa11f68da9e992285c8fa', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '7e33397a-3120-457d-8522-3dedf668cacc', '616_Checker01', 'Menbere Yehualashet Legass', '0913734984', '616', 'GERJI MARIAM', 'CHECKER',
  decode('5a1a96730c402b2efd223a9da9aecf26dd58c219b15e8ae3197636ac0bb9ecd9', 'hex'), decode('2ea6289778ebff036c2d975b245aecee', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '789e099a-3a50-49ce-9714-514ee091704f', '637_Maker01', 'Mekdes Assefa Seyfu', '0931528013', '637', 'GERJI MEBRAT HAYIL', 'MAKER',
  decode('913fae18bb4cd46768fb78759abfe28ed7179e4226596f867d3d1a0f62d8263c', 'hex'), decode('e95e5dc1b04b3edfb24f405963fd5b5f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '7a7bc796-82d0-4f96-adac-bb652fa1288b', '637_Checker01', 'Tesfaye Mengistu Tekle', '0910248712', '637', 'GERJI MEBRAT HAYIL', 'CHECKER',
  decode('94d5d65a4bd967cee7ad551273ead247cb6d9f71d15aeee91a7af74971bb3f74', 'hex'), decode('6fc51c75e9f01ddc76ccda8ec75d7f25', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '602c3491-128b-4c25-a0e1-32643ac38042', '622_Maker01', 'Tadese Gezahegn Demis', '0920371509', '622', 'AYAT ADDIS MENDER', 'MAKER',
  decode('8f35dbc51f69091b92fc505b3780e5fca5b1a2b0a6872a2f010e7827831bbbfe', 'hex'), decode('8d9c2c44151c0a693222d076a034e4ce', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '2871fafe-2dc7-440a-a1ad-c023b5d27f72', '622_Checker01', 'Alemnesh Misganaw Getaneh', '0921869036', '622', 'AYAT ADDIS MENDER', 'CHECKER',
  decode('17573d56d0e360c82d83b259f9fa01a3b374a073d615227c38121d1ed31a2116', 'hex'), decode('0199fa6a29274709af3993c3e69dd12a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '353e94a5-e810-42ee-9495-fceb2a97d401', '620_Maker01', 'Firehiwot Zemdkun Shiferaw', '0913068181', '620', 'BOLE CARGO', 'MAKER',
  decode('fa83c68271bc8be17b6696a25da63ca90d7f9571ffc2ea83c26c4e9242eef19b', 'hex'), decode('9a993d127758cc2b7201a93643ee47af', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b4c346c4-7af9-4fb1-b71d-ff1edba9373f', '620_Checker01', 'Atsedemariam Bekele Asfawe', '0927954383', '620', 'BOLE CARGO', 'CHECKER',
  decode('bbc18dd992fc1452328fa6905ff99a1a9823c3ced9d0f550556a2229acf3f98a', 'hex'), decode('6cc754966a41a3468c228a0eeb269977', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '91d29cc5-7948-41ba-8ee3-bc312f04a1fb', '608_Maker01', 'Yordanosh Hadosh', '0908818670', '608', 'LEMIKURA', 'MAKER',
  decode('a26f1ef25a65f31fcb0610282aeb2626fcfd22160ac025755dbe412dad197515', 'hex'), decode('e090ca41771a151c6cb3acf29389b7b7', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '7023b3d8-2b13-4851-8ff5-23ddf031d860', '608_Checker01', 'Habtamu Nuguse', '0933167725', '608', 'LEMIKURA', 'CHECKER',
  decode('1423c81b280328e8e9460c6d9aa1b5938fe35ea0552f587a784bc0519731d339', 'hex'), decode('64eb3fa99e24001e98c01a5c34dd8320', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '67d40848-241b-48b7-9289-597dc3cd46d6', '600_Maker01', 'Tigistu DebisaDino', '0941047286', '600', '24 STADIUM', 'MAKER',
  decode('25b34424312db3aa96a76f496b9106dc8772f528072e8edc241e34e1735c1284', 'hex'), decode('95a017466997ee8ef07cf1648d8e0614', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f3d8f110-6804-4881-ac0f-7521cbf93627', '600_Checker01', 'Meron Hilu Tekleargay', '0961968382', '600', '24 STADIUM', 'CHECKER',
  decode('31a2fbb4ffd6cf3acd4cbf7707f80388459eb6c0ab073cdd5b61a203fddcc816', 'hex'), decode('1ea7dd1f54b96e48b8d7e0854e2ce82c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'ffbbb214-d446-49a2-afd4-a765d523cbe4', '626_Maker01', 'Luel Shewafera Woldeyohannes', '0928409223', '626', 'MEHAL SUMMIT', 'MAKER',
  decode('dcd8b10c5e21b3cdfd7be508d72419f54c4f115fc407aafe4fddcbd1b565c350', 'hex'), decode('8fe586b32d996f32b66bfbeb8faf14fe', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'dd9679bf-635c-4021-97c3-fa83cce71c33', '626_Checker01', 'Sefefe Mengist Wondim', '0948252445', '626', 'MEHAL SUMMIT', 'CHECKER',
  decode('20891039c668fac866929a4ba6373c394112c250b51b5e8b3c4a96ce60ea3213', 'hex'), decode('67e85665dbd9b207e2469b59df1f409e', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b9d01070-63cc-4792-960f-66e4d5100a9a', '191_Maker01', 'Hanamariam Tesfaw', '0996509410', '191', 'LEBU MEBRAT', 'MAKER',
  decode('eb13a8b8491ef27f757cedc1463a6349c7c21ac5699d0ecf06f6ddecfc5edd9c', 'hex'), decode('57ddb2912779730f86f84ae0459e0eea', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '60c58b23-91d9-4ffd-9257-ec5d56e8791c', '191_Checker01', 'Lidiya Yidego', '0923271954', '191', 'LEBU MEBRAT', 'CHECKER',
  decode('85d3313b5f4d972fbbd4817abb2c5bc202dea7c88e8e08df71e8e76cc2709ed1', 'hex'), decode('1d4e70e7f05c01cae066763b795344d6', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '009ea79f-d77f-4cd0-a72b-e22bb7626ecb', '189_Maker01', 'Banchamlak Eskezia', '0948367680', '189', 'SUMMIT72', 'MAKER',
  decode('8b0b8822ec1570876624e525e9632dce8c86e760ee4da19e5c3e99607f6d3193', 'hex'), decode('eb28e608938654f55b22f24053cb1bcf', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '78f777f8-8b3d-401e-b037-5e511021ab31', '189_Checker01', 'Wubsira Bitew', '0951700260', '189', 'SUMMIT72', 'CHECKER',
  decode('b0a68133af190dc688308c584d4706d3030538e3672fced7acdace81357a61be', 'hex'), decode('135e7f14cc0d0b7ea4d18aad819b35f8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '2de0aba1-65c8-4090-ad0d-f269f1304c01', '193_Maker01', 'Siraw Enideg Belay', '0926479440', '193', 'BETHEL ALEMBANK', 'MAKER',
  decode('913c160be0d3b4cbc13c929f1599c9adfd914c51472ed1378ce885e191a5fddd', 'hex'), decode('8705858bfd29ba21cb01c3d7b1e6d684', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b5763e4e-7705-48b9-8dcc-17cf5e678c1a', '193_Checker01', 'Gete Girma Legesse', '0912060898', '193', 'BETHEL ALEMBANK', 'CHECKER',
  decode('2c54cb8a82d5e5ff2a7bdec60ad4a5e0a46788327794c853e50f7ea36db82feb', 'hex'), decode('99f2a9499f77fd9b3284046072982fb6', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8c694eea-53df-41bb-aeef-a85a5d9c4d6c', '414_Maker01', 'Melaku Gebeyi Malede', '0964980312', '414', 'ANFO ALPHA', 'MAKER',
  decode('8d6fd0fe58893a0e3283c808ad7684382b8569b9724b4ba66817ada9f4c33fbc', 'hex'), decode('2964f55b1fb58da69f294223c249959f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '765e93ce-a815-46ea-bab6-427f81437783', '414_Checker01', 'Dingeta Shanki Roba', '0910972305', '414', 'ANFO ALPHA', 'CHECKER',
  decode('7cad77c57fac4fb781adb874d3fe69ec5d928b89dadd471de4bc5af4cacaa326', 'hex'), decode('cf90c1468ee970da88da0ec687462e81', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd911a366-56c2-4632-8f9a-f40e50a532a9', '514_Maker01', 'Robiel Yohannes Meles', '0963527380', '514', 'ADIGRAT', 'MAKER',
  decode('261e87563defd465aa600115ee127fb4563d8f225bebc5cc8f8217da77da82af', 'hex'), decode('f1063b722295cbb189648f8643be7f24', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '43883d3b-f226-4715-8b9f-4a462a04743e', '514_Checker01', 'Haftamu Mahari Kindeye', '0914261687', '514', 'ADIGRAT', 'CHECKER',
  decode('ed77b37cc900fb60d6ed780079a57927e12077645ec8c807ebbfe6f4702ef08f', 'hex'), decode('63eb3f99d90b47d03cc0165d765d81e2', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '23c315d7-0ab4-47d9-acdb-1ff6148d5e90', '190_Maker01', 'Emebet Semahegn', '0909539660', '190', 'MEXICO PREMIUM', 'MAKER',
  decode('a1aa1bf11a8ed5411bd3b5999c9d30264ae74ab143f51944a31ce2a2f119ff32', 'hex'), decode('0b6440dc30ef02baec55d212a0615211', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd4192f82-24bb-4c4b-b85f-77fe5222926c', '190_Checker01', 'Mahlet Getachew Kasaye', '0922655635', '190', 'MEXICO PREMIUM', 'CHECKER',
  decode('6341910fec5fe2a36b35ebf6006f925b3201c5c4075dbb66dda2d09e9025a495', 'hex'), decode('fa6d59b8597d00bcf6af28bc987f7324', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '4147da70-d377-44ce-ba01-33a934119827', '186_Maker01', 'Yalemzewd Mulugeta Worku', '0921042365', '186', 'KARA ALO', 'MAKER',
  decode('4a9b11cc4680b50d74fc64f2d7380239ba03e1714b298d6fc121018e0dd6fe41', 'hex'), decode('17ae71ab32069de0a230e2139d3e446f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9a6c3b41-677b-48a1-9f80-ca0b02ccc8fe', '186_Checker01', 'Markos Gedlu G/Tsadik', '0913121357', '186', 'KARA ALO', 'CHECKER',
  decode('174a62c53137b9ea5e9c80712634ca067fcafc0c25bc7dfc6db1de0e924e5075', 'hex'), decode('af3db1a04db68d2d490923edec2f0df0', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '9153b8b1-4c8b-4c56-9900-d664f9e6c3a8', '183_Maker01', 'Tesfaye G/Medhen Abraham', '0912036424', '183', 'KOTEBE COLLEGE', 'MAKER',
  decode('d5cf58edb7be4d5279a33eeae4fea5d724b49f852953e142a26fe41f35e0618a', 'hex'), decode('7fcadb1efa4552d2096782663b4a067f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '6e13bb41-8980-421a-889f-49b7db0cabed', '183_Checker01', 'Atsed Abay Ayanaw', '0967143462', '183', 'KOTEBE COLLEGE', 'CHECKER',
  decode('35eb388a946d134e0e451ea5ab97c3ad1f96e1b58954d9d8cb1d2acb9052f52e', 'hex'), decode('5a4be8caead6917a6cd82c564b34ea84', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c7831875-f33e-44bd-aea3-2b0c853b2b0e', '184_Maker01', 'Genetie Tamene Wolle', '0945563286', '184', 'FIGA', 'MAKER',
  decode('c6e6471293fe017b9823ca7573433c163d586293f11df4fd18d957227c69683a', 'hex'), decode('ed675770cb0c1a8c4f1e8206313e1d12', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '85e2791c-d6c7-4f54-bf3f-532f33196e5a', '184_Checker01', 'Nurit Adem Ayele', '0922539984', '184', 'FIGA', 'CHECKER',
  decode('15b331a6d25712c95439733a46c1c4b329b3a06305fb70a587b4e84814efa806', 'hex'), decode('b5b62297f4d52a9387c1705a532e7dac', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3f3c70da-9544-4456-978d-71abe71c2c06', '633_Maker01', 'Tesfaye Worku Belay', '0943603769', '633', 'KILINTO', 'MAKER',
  decode('21bbf6500b2888ba50b36c9a5c62bb5d29679030d5499c33461bc9cc43eb0358', 'hex'), decode('3e1bde02abbef3636862278a86af2491', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '19739cf7-4544-471d-83c6-721809aac4e5', '633_Checker01', 'Getenesh Solomon Lemma', '0967554322', '633', 'KILINTO', 'CHECKER',
  decode('5124b40d7575b6a1d8ec1e494722dd7f5fa48afbd7d9c292be5a423af8a97689', 'hex'), decode('fce51039027e5175e59c98401cd91fb4', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e11f3f5a-3a0a-4b8c-a3ed-bbef65f12cb2', '200_Maker01', 'Sadiya Abdella Badi', '0948757342', '200', 'MERI LOKE', 'MAKER',
  decode('4e969d8758a93ccfe02f04fbff4240ba06d4c526114068a94f9d8032241fef5e', 'hex'), decode('0290ef31a45c4a9c3b18a42aab86098f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '94f07868-ff6d-4700-94c0-613a4abf7691', '200_Checker01', 'Temesgen Endalew Ayalay', '0931878283', '200', 'MERI LOKE', 'CHECKER',
  decode('fab8ac8e205c964bf66720c761c6b8a4d19ffd7ed857f7d77b9637f1c148407c', 'hex'), decode('a7ece438fd7e9c074c895bdad867194d', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '688cfce9-ea33-441b-8786-5023631708b7', '638_Maker01', 'Yenenesh Kassa Balcha', '0922949047', '638', 'Garment Atikilit Tera', 'MAKER',
  decode('b22bdc69eec3b357d99d01ce70ee8f24c2505d6d3167d17dd4fef166da770edd', 'hex'), decode('31de24bace9a757362a4b69f48404ea0', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '60b5e232-3258-4232-9311-f51f0ff499c8', '638_Checker01', 'Seyoum Hunde Feyisa', '0943824313', '638', 'Garment Atikilit Tera', 'CHECKER',
  decode('f563416c2c9ac73d35930461adf9bcc08682cc6810141e116a1075c0d6e32263', 'hex'), decode('bfcf10fb3f6aaef57a391e1327457e4f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '4cdde05a-34dc-4fcf-a37f-8fe01246203b', '617_Maker01', 'Ermias Arega Wolde', '0904103667', '617', 'AYAT 5', 'MAKER',
  decode('e8659b060d3868dd1cb9a592334576aa37b362897f7715d95c44ad4644ba4a0d', 'hex'), decode('2ee71960933912b9c0b1adb06f48ec33', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5bfe0e3e-c710-423b-8c42-adf74bc6f896', '617_Checker01', 'Tiliksew Molla Tiruneh', '0945714298', '617', 'AYAT 5', 'CHECKER',
  decode('f389162aa86d78ce9b3de66a553f13a1871acb54eaaba56ab1c169acf6d0b91b', 'hex'), decode('8239db18585568a2ef781e475fe2fdc4', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1e8f9570-8a74-4c77-810d-1c12ee80ab5d', '627_Maker01', 'Abebe Daba Dufera', '0945686909', '627', 'BULGARIA', 'MAKER',
  decode('06886b2673389f0e298347e7b952b7e617afe52cdef804e947bec638a314e86a', 'hex'), decode('11e36e6f7e31bb49e1506424863354e3', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '07db9fe0-b753-4e7a-b830-974db6b9ac03', '627_Checker01', 'Alesa Biyadgie Belete', '0903009237', '627', 'BULGARIA', 'CHECKER',
  decode('d040ce1b49ea4eabe083c1e2828fcb47e1abafe464f573811b5662df1574db4c', 'hex'), decode('94bf5e18de451afe2e94a2eaa6c6d47c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '26d959c6-7d80-41fe-8afb-17d15b6ee838', '636_Maker01', 'Dawit Tefera Tekalign', '0966730141', '636', 'SUMMIT MEDIHANEALEM', 'MAKER',
  decode('6479d3939bb8f9646226e9ecd0377c1a530db172b28eff41053d4e888552b742', 'hex'), decode('7b6daf52e648869b39cf4789b8aff16a', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'c287fddf-d6b1-44b5-ab83-2cbcb260b125', '636_Checker01', 'Netsanet Negi Biru', '0912199966', '636', 'SUMMIT MEDIHANEALEM', 'CHECKER',
  decode('fc5403b44f99f9c6b73f7964902f9383bf3d5e9f0fc5bca0f40accfabb37f2b3', 'hex'), decode('de0f7f4e21b4ecd963f5ac27626220f2', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '29620f6f-0c5e-46ee-85bc-d3843515df6e', '199_Maker01', 'Ebise Gadisa Terfa', '0931656737', '199', 'BULGARIA MAZORIA', 'MAKER',
  decode('c5df843cab3ec0d687b43292c8263355e44964843003b89f991423c509682f74', 'hex'), decode('28c4cbf0fbafef8c736d612f2438da47', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a20f1b3e-d216-4eb4-9029-87d2e64c7e24', '199_Checker01', 'Diriba Yoseph', '0911301510', '199', 'BULGARIA MAZORIA', 'CHECKER',
  decode('52f497e816444cd487dfa936c330b3057cd847f6f45d77a035c152017db0d220', 'hex'), decode('b17808f09691ce706e82a486e1473775', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '49cd589b-4314-43fb-9223-8c12a30a174d', '188_Maker01', 'Yezbalem Melkie', '0918738614', '188', 'AYAT TAFO', 'MAKER',
  decode('e947eca14b55b19a44849b8d61aecb5f3a08b97c5307bfa936b7858d6dba7de4', 'hex'), decode('f4557a0caa04d75eb4492fb477c28ee4', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a76cd94d-e00b-4adb-938c-136817b96bd1', '188_Checker01', 'Mekdes Mulugeta Negash', '0925512689', '188', 'AYAT TAFO', 'CHECKER',
  decode('97df5cb3e232634f026706267834749e9f994d6a1a3a7e81c59572c964ffe002', 'hex'), decode('611631882ca90d4becfcd2267aa1b303', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '67731f91-4dbd-4a12-9490-0a3520416583', '606_Maker01', 'Biruk Abebe Haile', '0924366250', '606', 'SEBATEGNA', 'MAKER',
  decode('913f3acf335409ce0af433b57748240bef07a7459cdf39bba5889164ddef4ea4', 'hex'), decode('79262c4b312a0cc6495d9df8352e1a80', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '08667b8d-400a-4e33-95d1-d022423f68b3', '606_Checker01', 'Andamlak G/senbet Jenbere', '0919799905', '606', 'SEBATEGNA', 'CHECKER',
  decode('c0cf908829fed3e98850cc6e282a6f09616f9ba25059ef621cbabb1c6e118c94', 'hex'), decode('5cf6ca480b6a308dffe4a9ebf6e788e3', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '884391ea-0574-49ec-83ae-ccfb2c87d09a', '611_Maker01', 'Destaw Mesafint Tassew', '0913561471', '611', 'CHID TERA', 'MAKER',
  decode('455a7cb561f7af538ebd43222713466627b8e2d528d635522c26b31ba8948963', 'hex'), decode('a0c8417421ce77f6168cc46f325aa2f7', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '89fcd938-9944-4b0d-bf25-3ac6501a5535', '611_Checker01', 'Fikadu Kabeba Hurissa', '0912448828', '611', 'CHID TERA', 'CHECKER',
  decode('50f95c7e632edb2dae234bc375ea5353906e7b153e2d76a90302dfb1a4c77865', 'hex'), decode('ce8548564754acfc5ea7deae474cc327', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'a5f7c73e-147d-48ba-aa75-17c5625e2efa', '605_Maker01', 'Meaza Alebachew Fantahun', '0924312880', '605', 'BULBULA 93 MAZORIA', 'MAKER',
  decode('7ea965bbe168158c8feb61d61de860b8f508820634e8a00733fb17a5502d5128', 'hex'), decode('07b22e5e5389eead5f086dc089b3e2ac', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1270be00-ced3-43e1-bb0a-6a1e4eabac99', '605_Checker01', 'Siyum Huray Hulumyfer', '0938300508', '605', 'BULBULA 93 MAZORIA', 'CHECKER',
  decode('205214fd2f88d5bae877d9dbd67562e8dfff61d1e016610c6b7eddd690eadf4b', 'hex'), decode('5e5878cad6293ab7966d112595a84b7f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '25dde053-24f1-4e3f-bf02-c94ccfa432ff', '614_Maker01', 'Biruktawit Arega Mitike', '0916836435', '614', 'BULBULA CONDOMINIUM', 'MAKER',
  decode('258c8a66a91fe31d11bf2e4be8d704c2b137a79d08da7baa635fa2356838dc97', 'hex'), decode('7f233e8c3e81b76c44e3ac1443615126', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '54498280-034b-4bd4-9e9c-79f46b85213b', '614_Checker01', 'Alemberhan Tsegaye', '0911762685', '614', 'BULBULA CONDOMINIUM', 'CHECKER',
  decode('696480f953714cc20a9225aeffa6f87c511ccdbd591553e3afb003dbbaeab2d8', 'hex'), decode('5a61b7135ce50a9b80431481cf982107', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3aa574f1-dd6e-4f8a-bb63-a734fa399eb6', '634_Maker01', 'Mulu Nigus Alamirew', '0928517931', '634', 'KALITY WUHALIMAT', 'MAKER',
  decode('e369a94fc29b50190e67495b1365844df4fe2c56c5691ba76e7e836db23054d9', 'hex'), decode('ef865b79f2e37cc53692f33153fffd3f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '3f309ab8-e6e8-40df-b8eb-2eb572dca539', '634_Checker01', 'Lemlem Aseffa Setegn', '0942752179', '634', 'KALITY WUHALIMAT', 'CHECKER',
  decode('4ba6dcdf9de6f33db8233302e2b4841caf25c2fff183eac63397c688979abfe0', 'hex'), decode('46c84e724b92109f1a24c79dc92c4707', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b970de96-7203-488e-bf80-0c6eb5b4d60a', '516_Maker01', 'Fissha Mamu Kidane', '0908212907', '516', 'AXUM', 'MAKER',
  decode('4d281d185551a4231cb21761386209b6532bd8c371c89feef1ace8ed3df97279', 'hex'), decode('9c92c4faff49404c06e9cef1aa389c44', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5c0ac3ef-5d7e-43ee-b834-396c231d4157', '516_Checker01', 'Tadesse Gebremichael Teklu', '0920461663', '516', 'AXUM', 'CHECKER',
  decode('d7a6de4fb6224bce4c85f3e3de2c91053a7335834caacc5f77b69829b2a58ba1', 'hex'), decode('d10400a57a4070c758430a53079523a0', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '4ea295cb-e9cc-4cf6-8bb7-871521e35c79', '187_Maker01', 'Malede Agegnew Assefa', '0986284241', '187', 'DEMBEL', 'MAKER',
  decode('3e60bd6a1329970fe605af669f041caab2e64368ae630e300f84bb42ea433a12', 'hex'), decode('a91e528fb0f86d0bac3a2f05062e72b9', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '439804f3-8cd2-44c5-876b-a2c8b0bece6c', '187_Checker01', 'Tesfahun Belay Getachew', '0936436204', '187', 'DEMBEL', 'CHECKER',
  decode('ef00a546cd518e9f02346441887c792e2ad0ffaeace36d8a1f54bcf884410e50', 'hex'), decode('cf39c431abefec7c0b907d639b7e6957', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '51b1c2c4-13a6-4dfd-a227-b067057f2127', '635_Maker01', 'Tenagne Wonedie', '0920496939', '635', 'BIHERAWE', 'MAKER',
  decode('746f15cfda607142819b0757b2c776b058779e4f198c2b8b030bfd05e442bddb', 'hex'), decode('c81b3eff52020d3dec5138957abb6b4e', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'eaea2387-80fd-4a8e-a3e2-9289531721da', '635_Checker01', 'Kidist Ayalew', '0972315253', '635', 'BIHERAWE', 'CHECKER',
  decode('1cf1e8b1939c8cb68c5c2d3e23b5f262e185d8bfdb56d926413aa0ee3a9ceca0', 'hex'), decode('731cec03d116938494dba8faab016121', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '86f09722-5736-400d-b284-23d32f7d5556', '416_Maker01', 'Selam Baneyigegn Shibabaw', '0909758982', '416', 'ASSOSA', 'MAKER',
  decode('a2381afeb1645d083964f7dd7b6552699dcde0688f5c45be7448517132f1f61b', 'hex'), decode('531f192aed308c30a7ad8b7a88ec277c', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '5c0be1cf-c1b0-4637-89c3-07eff298f9d7', '416_Checker01', 'Gebeyehu Abebe Jiru', '0985906749', '416', 'ASSOSA', 'CHECKER',
  decode('9d12c5c5dc346a9cadb3912a8730e144564bbab28c9ef257ade98bc3940b8380', 'hex'), decode('cbc4d78133a1402499452b777a977525', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '115b339e-9770-4607-82e8-6f96762f6c39', '629_Maker01', 'Asinake Ediso Esha', '0902897061', '629', 'MEHAL LAMBERET', 'MAKER',
  decode('2d66bc4114d3998137367627803715057699f26e13ec88b5e0fae75902ea9bb2', 'hex'), decode('c96b57d02b3015823d02f40909f46440', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '62d42c0b-56a8-469a-9ac4-adee9f897d37', '629_Checker01', 'Aynalem Gulelat Zergaw', '0912216175', '629', 'MEHAL LAMBERET', 'CHECKER',
  decode('54b8fe2afb24c8921a0a83ee775fc5278da8541a2757a5901c19ce666e162298', 'hex'), decode('56d94dd4aadb4fbd77b54713cdadfb72', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '0a1423b3-1de9-4cb2-8cc1-12c617084f8f', '192_Maker01', 'Eshetu Angasu Gebre', '0953106622', '192', 'WUHALIMAT DILDIY', 'MAKER',
  decode('d97ba17cc9ee1f079778e387b00ca3f9f272851f97c576a3146bee43940728cb', 'hex'), decode('83fd6f52d6332a87f1be649d4ecf4ac5', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '81e4de93-30df-4942-b2a2-2abc596403e2', '192_Checker01', 'Abel Solomon Andarge', '0973183484', '192', 'WUHALIMAT DILDIY', 'CHECKER',
  decode('362e8a459f0fd169e983c34217ec7d4264853bfbd538c7147eef5b592c100a84', 'hex'), decode('b0e1937a4b25c099e3f8eef9916acab8', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e9859dc4-a145-46b9-b511-adf3ddffe441', '513_Maker01', 'Tekie Mehari Beyene', '0960707974', '513', 'SHIRE', 'MAKER',
  decode('33df6ab76bb13c6fe89297817d8b41935dffdc72b130a277a5b19cfd4fee1abf', 'hex'), decode('85309c4c4b1704235e4e31768df4ef3f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'f5b21b70-b270-449a-9794-1258912ecd48', '513_Checker01', 'Amaha Atalay', '0914231083', '513', 'SHIRE', 'CHECKER',
  decode('ba801451625040ca34487dd90ca3aa2e6db43712596ee8ce2def1589e927f784', 'hex'), decode('dcf57ac2da54c74ce8bba22a0a81ddd2', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '74b134a0-318a-4603-9d9b-5bb0b6d1203d', '613_Maker01', 'Rediet Fikre Desta', '0932120917', '613', 'SUMMIT GIORGIS', 'MAKER',
  decode('a768af6e49a66b205fc2bfcea158c3595accd53e995d0d307eb2e9c678ace826', 'hex'), decode('d353dbe65d772f54678326b7c6521422', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '043dd264-1133-4bad-870f-d9d8b58238b4', '613_Checker01', 'Wudineh Nigusse', '0949336095', '613', 'SUMMIT GIORGIS', 'CHECKER',
  decode('b50a4211907c9847051288a73803dcee389acbda98d5b5cca5fac105cff87533', 'hex'), decode('780a5233bbb40b5fcf39d435f4317e3e', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'dbc0fa02-30e1-4be4-ade9-220cf6460876', '625_Maker01', 'Adisalem Ketsela Mengistu', '0921797289', '625', 'AYAT 72', 'MAKER',
  decode('faef7e4c9c3b3ad59e690bfecbb3524a94d8afa5f69c5df4cc56a6a195fae771', 'hex'), decode('cf09d87b74a0246489009bdcb453d76f', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'b6cc5825-3992-4d3c-877c-dac4ccf6b65c', '625_Checker01', 'Muluna Boka Wanga', '0919868404', '625', 'AYAT 72', 'CHECKER',
  decode('e03613c9a3c1f0ee413de2602754c92bd959ee59a8e77193b4c879b92d715a09', 'hex'), decode('a8b052021f5a1d00597a24901c7ec4e1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '809aa9f9-0fe8-421e-8ddc-a0a720bf9384', '631_Maker01', 'Yemisrach Moges Mekuria', '0927944468', '631', 'LEM HOTEL', 'MAKER',
  decode('217bcc3f7585f5b78770af628d473d0ac56dff6630508f0cd116621dcdab4870', 'hex'), decode('b6c0cb3072ad0f2f1060ae0321f46185', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd653c485-322c-49f3-bd4b-eeb4bb9ee612', '631_Checker01', 'Selamawit Birle Alachew', '0912175532', '631', 'LEM HOTEL', 'CHECKER',
  decode('107257e08597e24c6f0cbd547985dc28163ec279cf878338395dbf60f28122fa', 'hex'), decode('f36f32cece176ff8ef4f510a97c943e1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1c771ca8-807f-419c-8511-2e21a6406274', '618_Maker01', 'Makdas Eyob Amiso', '0996988530', '618', 'MEHAL LAFTO', 'MAKER',
  decode('d84c4d6c0ebcac9ae656e22a0c590f5a9838c153566b2b86d5771397ffaf4d35', 'hex'), decode('d613c6d9b2eac681bb680f3c2255faf7', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '8ad2fb9a-f87b-4192-b62f-f07502181ce0', '618_Checker01', 'Felege Lakie Ayalneh', '0934960722', '618', 'MEHAL LAFTO', 'CHECKER',
  decode('70b1e06cbb5d7e836bd514d16b0a3bd0c788c4ded54e35355cfafead76923509', 'hex'), decode('5ce14495d24a662a2ff2262df498c012', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'e9280bc2-90d3-41da-aca3-f71299d82530', '621_Maker01', 'Desalegn Ewnetie Setegn', '0914764558', '621', 'GORO ADEBABAY BRANCH', 'MAKER',
  decode('eac342e62f8254f952d0bff7dab294f82df99ba3e1c3d799da0b1aac1f24d519', 'hex'), decode('916da13424063f2b673ebcf357847e10', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  'd82cde53-a1de-42d2-8614-19c8ce981273', '621_Checker01', 'Meles Kidane Mekonnen', '0901738528', '621', 'GORO ADEBABAY BRANCH', 'CHECKER',
  decode('aa2475baa312532b92827560cd18fd1083ed0c6b9833a4094d7071a8ec71f894', 'hex'), decode('f80c0e2aed6e53bc5aa27c05f01e8812', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '2bd8f0a7-7cd8-4fc6-a070-e9e5f52cad09', '612_Maker01', 'Tsegenet Degu Degago', '0933584220', '612', 'LAFTO VIEW', 'MAKER',
  decode('989c13d4582f6c31927e347346c76933ed269fd33349f1cae21f668ca64eda25', 'hex'), decode('c9b1ff90c77048b4e094aa60022017c1', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

INSERT INTO "Users" (
  "Id", "Username", "FullName", "PhoneNumber", "BranchCode", "BranchName", "Role",
  "PasswordHash", "PasswordSalt", "MustChangePassword", "PasswordChangedAtUtc", "IsActive", "CreatedAtUtc", "LastLoginAtUtc"
) VALUES (
  '1e05392d-2d7c-4ad4-9c19-23f70118c05c', '612_Checker01', 'Temesgen Nigussu Kassa', '0922365302', '612', 'LAFTO VIEW', 'CHECKER',
  decode('f288a4bf3970a6c089f015615186adbca2b514edd6a3c17dd88365512b5fb295', 'hex'), decode('e4c8c610b1cb0f762bead805559acb01', 'hex'), TRUE, NULL, TRUE, NOW() AT TIME ZONE 'UTC', NULL
)
ON CONFLICT ("Username") DO UPDATE
SET "FullName" = EXCLUDED."FullName",
    "PhoneNumber" = EXCLUDED."PhoneNumber",
    "BranchCode" = EXCLUDED."BranchCode",
    "BranchName" = EXCLUDED."BranchName",
    "Role" = EXCLUDED."Role",
    "PasswordHash" = EXCLUDED."PasswordHash",
    "PasswordSalt" = EXCLUDED."PasswordSalt",
    "MustChangePassword" = TRUE,
    "PasswordChangedAtUtc" = NULL,
    "IsActive" = EXCLUDED."IsActive";

COMMIT;
