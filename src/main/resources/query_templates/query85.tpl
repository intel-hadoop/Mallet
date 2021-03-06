--
-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements. See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License. You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

DEFINE COMMENT = "-- ";
[COMMENT] QUERY_ID=85;

 define MS= ulist(dist(marital_status, 1, 1), 3);
 define ES= ulist(dist(education, 1, 1), 3);
 define STATE= ulist(dist(fips_county, 3, 1), 9);
 define YEAR= random(1998,2002, uniform);
 define _LIMIT=100;

 select  substr(r_reason_desc,1,20) as rrd
       ,avg(ws_quantity) as wq
       ,avg(wr_refunded_cash) as wrc
       ,avg(wr_fee) as wf
 from 
    web_sales ws join web_returns wr
      on ws.ws_item_sk = wr.wr_item_sk
      and ws.ws_order_number = wr.wr_order_number
    join web_page wp
      on ws.ws_web_page_sk = wp.wp_web_page_sk
    join customer_demographics cd1
      on cd1.cd_demo_sk = wr.wr_refunded_cdemo_sk 
    join customer_demographics cd2
      on cd2.cd_demo_sk = wr.wr_returning_cdemo_sk
    join customer_address ca
      on ca.ca_address_sk = wr.wr_refunded_addr_sk
    join date_dim d
      on ws.ws_sold_date_sk = d.d_date_sk
      and d.d_year = [YEAR]
    join reason r
      on r.r_reason_sk = wr.wr_reason_sk
 where
   (
    (
     cd1.cd_marital_status = '[MS.1]'
     and
     cd1.cd_marital_status = cd2.cd_marital_status
     and
     cd1.cd_education_status = '[ES.1]'
     and 
     cd1.cd_education_status = cd2.cd_education_status
     and
     ws_sales_price between 100.00 and 150.00
    )
   or
    (
     cd1.cd_marital_status = '[MS.2]'
     and
     cd1.cd_marital_status = cd2.cd_marital_status
     and
     cd1.cd_education_status = '[ES.2]' 
     and
     cd1.cd_education_status = cd2.cd_education_status
     and
     ws_sales_price between 50.00 and 100.00
    )
   or
    (
      cd1.cd_marital_status = '[MS.3]'
     and
     cd1.cd_marital_status = cd2.cd_marital_status
     and
     cd1.cd_education_status = '[ES.3]'
     and
     cd1.cd_education_status = cd2.cd_education_status
     and
     ws_sales_price between 150.00 and 200.00
    )
   )
   and
   (
    (
     ca_country = 'United States'
     and
     ca_state in ('[STATE.1]', '[STATE.2]', '[STATE.3 ]')
     and ws_net_profit between 100 and 200  
    )
    or
    (
     ca_country = 'United States'
     and
     ca_state in ('[STATE.4]', '[STATE.5]', '[STATE.6]')
     and ws_net_profit between 150 and 300  
    )
    or
    (
     ca_country = 'United States'
     and
     ca_state in ('[STATE.7]', '[STATE.8]', '[STATE.9]')
     and ws_net_profit between 50 and 250  
    )
   )
group by r_reason_desc
order by rrd
        ,wq
        ,wrc
        ,wf
[_LIMITC];

