CREATE TABLE `client` (
                          `client_num` INT NOT NULL PRIMARY KEY auto_increment,
                          `client_name` VARCHAR(255) NOT NULL,
                          `client_id` VARCHAR(255) NOT NULL,
                          `client_pw` VARCHAR(255) NOT NULL,
                          `client_email` VARCHAR(255) NOT NULL,
                          `client_phone` VARCHAR(255) NOT NULL,
                          `client_type` VARCHAR(255) NOT NULL check (client.client_type in('회원', '운영자')),
                          `client_gender` VARCHAR(10) check (client.client_gender in('남', '여')),
                          `client_birth` DATE,
                          `client_nickname` VARCHAR(255),
                          `client_brand` VARCHAR(255),
                          `client_certification` BOOLEAN default false,
                          `client_status` VARCHAR(255) NOT NULL DEFAULT 'active' check (client_status in('active','inactive','black')) ,
                          `client_report_cnt` INT NOT NULL DEFAULT 0
);

CREATE TABLE `category` (
                            `category_num` INT NOT NULL PRIMARY KEY auto_increment,
                            `category_type` VARCHAR(255) NOT NULL
);

CREATE TABLE `popup` (

                         `popup_post_num` INT NOT NULL auto_increment,
                         `client_num` INT NOT NULL ,
                         `popup_name` VARCHAR(255) NOT NULL,
                         `popup_content` VARCHAR(255) NOT NULL,
                         `popup_start_date` TIMESTAMP NOT NULL,
                         `popup_end_date` TIMESTAMP NOT NULL,
                         `popup_status` VARCHAR(255) NOT NULL check ( popup_status in ('진행 전','진행 중','마감')),
                         `popup_post_upload_time` TIMESTAMP NOT NULL,
                         `popup_location1` VARCHAR(255) NOT NULL,
                         `popup_location2` VARCHAR(255) NOT NULL,
                         `popup_location3` VARCHAR(255) NOT NULL,
                         `popup_location4` VARCHAR(255) NOT NULL,
                         `popup_ticket_amount` INT NOT NULL check ( popup_ticket_amount >= 0 ),
                         `popup_ticket_per_price` INT NOT NULL check ( popup_ticket_per_price >= 0 ),
                         `popup_post_check` BOOLEAN NOT NULL DEFAULT FALSE,
                         `category_num` INT NOT NULL,
                         PRIMARY KEY (`popup_post_num`, `client_num`),
                         FOREIGN KEY (`client_num`) REFERENCES `client`(`client_num`) ON DELETE CASCADE ON UPDATE CASCADE,
                         FOREIGN KEY (category_num) references category(category_num) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `post_img` (
                            `post_img_num` INT NOT NULL auto_increment,
                            `popup_post_num` INT NOT NULL,
                            `post_img_name` VARCHAR(255) NOT NULL,
                            `post_img_rename` VARCHAR(255) NOT NULL,
                            `post_img_type` VARCHAR(255) NOT NULL,
                            `post_img_url` VARCHAR(255) NOT NULL,
                            PRIMARY KEY (`post_img_num`, `popup_post_num`),
                            FOREIGN KEY (`popup_post_num`) REFERENCES `popup`(`popup_post_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `review` (
                          `review_num` INT NOT NULL auto_increment,
                          `client_num` INT NOT NULL,
                          `popup_post_num` INT NOT NULL,
                          `review_title` VARCHAR(255) NOT NULL,
                          `review_content` VARCHAR(255) NOT NULL,
                          `review_upload_time` TIMESTAMP NOT NULL,
                          `review_rating` INT NOT NULL check(0<= review_rating <=5),
                          PRIMARY KEY (`review_num`, `client_num`, `popup_post_num`),
                          FOREIGN KEY (`client_num`) REFERENCES `client`(`client_num`) ON DELETE CASCADE ON UPDATE CASCADE,
                          FOREIGN KEY (`popup_post_num`) REFERENCES `popup`(`popup_post_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `review_img` (
                              `review_img_num` INT NOT NULL auto_increment,
                              `review_num` INT NOT NULL,
                              `review_img_name` VARCHAR(255) NOT NULL,
                              `review_img_rename` VARCHAR(255) NOT NULL,
                              `review_img_type` VARCHAR(255) NOT NULL,
                              `review_img_url` VARCHAR(255) NOT NULL,
                              PRIMARY KEY (`review_img_num`, `review_num`),
                              FOREIGN KEY (`review_num`) REFERENCES `review`(`review_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `pay` (
                       `pay_num` INT NOT NULL auto_increment,
                       `popup_post_num` INT NOT NULL,
                       `pay_time` TIMESTAMP NOT NULL,
                       `pay_price` INT NOT NULL,
                       `pay_amount` INT NOT NULL,
                       `pay_method` VARCHAR(255) NOT NULL,
                       `client_num` INT NOT NULL,
                       `pay_return` BOOLEAN NOT NULL default false,
                       PRIMARY KEY (`pay_num`, `popup_post_num`),
                       FOREIGN KEY (`popup_post_num`) REFERENCES `popup`(`popup_post_num`) ON DELETE CASCADE ON UPDATE CASCADE,
                       FOREIGN KEY (`client_num`) REFERENCES `client`(`client_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `review_like` (
                               `review_num` INT NOT NULL PRIMARY KEY,
                               `review_like_num` INT NOT NULL DEFAULT 0 check(review_like_num>=0),
                               FOREIGN KEY (`review_num`) REFERENCES `review`(`review_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `ticket` (
                          `ticket_code` VARCHAR(255) NOT NULL,
                          `pay_num` INT NOT NULL,
                          `ticket_time` TIMESTAMP NOT NULL,
                          `ticket_use` BOOLEAN NOT NULL DEFAULT TRUE,
                          PRIMARY KEY (`ticket_code`, `pay_num`),
                          FOREIGN KEY (`pay_num`) REFERENCES `pay`(`pay_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `refund` (
                          `refund_num` INT NOT NULL PRIMARY KEY auto_increment,
                          `pay_num` INT NOT NULL,
                          `refund_time` TIMESTAMP NOT NULL,
                          FOREIGN KEY (`pay_num`) REFERENCES `pay`(`pay_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `admin_q_comment` (
                                   `admin_q_comment_num` INT NOT NULL auto_increment,
                                   `client_num` INT NOT NULL,
                                   `admin_q_comment_time` TIMESTAMP NOT NULL,
                                   `admin_q_comment_content` VARCHAR(255) NOT NULL,
                                   PRIMARY KEY (`admin_q_comment_num`, `client_num`),
                                   FOREIGN KEY (`client_num`) REFERENCES `client`(`client_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `comment` (
                           `comment_num` INT NOT NULL auto_increment,
                           `review_num` INT NOT NULL,
                           `client_num` INT NOT NULL,
                           `comment_content` VARCHAR(255) NOT NULL,
                           `comment_upload_time` TIMESTAMP NOT NULL,
                           PRIMARY KEY (`comment_num`, `review_num`, `client_num`),
                           FOREIGN KEY (`review_num`) REFERENCES `review`(`review_num`) ON DELETE CASCADE ON UPDATE CASCADE,
                           FOREIGN KEY (`client_num`) REFERENCES `client`(`client_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `comment_report` (
                                  `comment_report_num` INT NOT NULL PRIMARY KEY auto_increment,
                                  `comment_report_content` VARCHAR(255) NOT NULL,
                                  `comment_report_check` BOOLEAN NOT NULL DEFAULT FALSE,
                                  `comment_num` INT NOT NULL,
                                  `client_num` INT NOT NULL,
                                  FOREIGN KEY (`comment_num`) REFERENCES `comment`(`comment_num`) ON DELETE CASCADE ON UPDATE CASCADE,
                                  FOREIGN KEY (`client_num`) REFERENCES `client`(`client_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `review_report` (
                                 `review_report_num` INT NOT NULL PRIMARY KEY auto_increment,
                                 `review_report_content` VARCHAR(255) NOT NULL,
                                 `review_report_check` BOOLEAN NOT NULL DEFAULT FALSE,
                                 `review_num` INT NOT NULL,
                                 `client_num` INT NOT NULL,
                                 FOREIGN KEY (`review_num`) REFERENCES `review`(`review_num`) ON DELETE CASCADE ON UPDATE CASCADE,
                                 FOREIGN KEY (`client_num`) REFERENCES `client`(`client_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `post_q` (
                          `post_q_num` INT NOT NULL auto_increment,
                          `client_num` INT NOT NULL,
                          `popup_post_num` INT NOT NULL,
                          `post_q_upload_time` TIMESTAMP NOT NULL,
                          `post_q_content` VARCHAR(255) NOT NULL,
                          PRIMARY KEY (`post_q_num`, `client_num`, `popup_post_num`),
                          FOREIGN KEY (`client_num`) REFERENCES `client`(`client_num`) ON DELETE CASCADE ON UPDATE CASCADE,
                          FOREIGN KEY (`popup_post_num`) REFERENCES `popup`(`popup_post_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `post_q_comment` (
                                  `post_q_comment_num` INT NOT NULL PRIMARY KEY auto_increment,
                                  `post_q_comment_content` VARCHAR(255) NOT NULL,
                                  `post_q_comment_upload_time` TIMESTAMP NOT NULL,
                                  `post_q_num` INT NOT NULL,
                                  FOREIGN KEY (`post_q_num`) REFERENCES `post_q`(`post_q_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `client_img` (
                              `client_img_num` INT NOT NULL auto_increment,
                              `client_num` INT NOT NULL,
                              `client_img_type` VARCHAR(255) NOT NULL,
                              `client_img_url` VARCHAR(255) NOT NULL,
                              PRIMARY KEY (`client_img_num`, `client_num`),
                              FOREIGN KEY (`client_num`) REFERENCES `client`(`client_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE favorite_list (
                               client_num INT NOT NULL ,
                               popup_post_num INT NOT NULL auto_increment,
                               PRIMARY KEY (client_num, popup_post_num),
                               FOREIGN KEY (client_num) REFERENCES client(client_num) ON DELETE CASCADE ON UPDATE CASCADE,
                               FOREIGN KEY (popup_post_num) REFERENCES popup(popup_post_num) ON DELETE CASCADE ON UPDATE CASCADE
);

