select
  task_id,
  task_name,
  regexp_substr(task_name,'[-+]?[0-9]*\.?[0-9]+') as task_number,
  custom_vw_plan_id as vw_plan_id,
  custom_enterprise as enterprise,
  custom_sh_type as sh_type,
  custom_current_year as current_year,
  custom_prior_year as prior_year,
  custom_missing_compensation as missing_compensation,
  custom_other_plan as other_plan,
  custom_402_g_limit as "402_g_limit",
  custom_415_limit as "415_limit",
  custom_active_elig_12_31_eoy_ as active_elig_12_31_eoy_,
  custom_th_this_year as th_this_year,
  custom_match_cal_period as match_cal_period,
  custom_profit_sharing as profit_sharing,
  custom_match as match,
  custom_date_sent_yyyy_mm_dd_ as date_sent_yyyy_mm_dd_,
  custom_adp_test_result as adp_test_result,
  custom_acp_test_result as acp_test_result,
  custom_prior_year_adp as prior_year_adp,
  custom_prior_year_acp as prior_year_acp,
  custom_d_3_discrepancies as d_3_discrepancies,
  custom_th_next_year as th_next_year,
  custom_funding_deadline_2022_mm_dd_ as funding_deadline_2022_mm_dd_,
  conversation,
  number_of_comments,
  tags,
  task_description,
  assignee_user_id,
  assignee_name,
  project_id,
  is_completed,
  completed_at,
  completed_by_user_id,
  created_at,
  due_date,
  first_modifier_name,
  modified_at,
  custom_task_mins as task_mins,
  task_link,
  days_open,
  is_currently_assigned,
  has_been_assigned,
  days_since_last_assignment,
  days_since_first_assignment,
  last_assigned_at,
  first_assigned_at
from {{ ref('asana__task') }}

--the below script allows for passing project_id's to filter the query.
{% if var('year_end_testing_project_ids') %}
where
    project_id in (
{{ var('year_end_testing_project_ids') | join (", ") }}
)
{% endif %}

--add custom field pass throughs
