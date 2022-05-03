select
  task_id,
  task_name,
  regexp_substr(task_name,'(C3 )+[0-9]*\.?[0-9]') as task_number,
  custom_vw_plan_id as vw_plan_id,
  custom_company_address_1 as address,
  custom_company_affil_serv_grp as company_affil_serv_grp,
  custom_company_city as company_city,
  custom_company_cont_grp as company_cont_grp,
  custom_company_employer_id as company_employer_id,
  custom_company_name as company_name,
  custom_company_phone as company_phone,
  custom_company_phone_ac as company_phone_ac,
  custom_company_state as company_state,
  custom_company_tax_year as company_tax_year,
  custom_company_zip as company_zip,
  custom_drafting_round as drafting_round,
  custom_entity_type as entity_type,
  custom_issue_dual_eligibility as issue_dual_eligibility,
  custom_issue_excluded_employees as issue_excluded_employees,
  custom_issue_fringe_benefit_exclusion as issue_fringe_benefit_exclusion,
  custom_issue_missing_joinder_agreements as issue_missing_joinder_agreements,
  custom_issue_plan_year_end as issue_plan_year_end,
  custom_issue_pre_entry_comp_exclusion as issue_pre_entry_comp_exclusion,
  custom_issue_prior_year_testing as issue_prior_year_testing,
  custom_issue_write_in_comp_exclusion as issue_write_in_comp_exclusion,
  custom_joinder_list as joinder_list,
  custom_plan_line_1 as plan_line_1,
  custom_trustee_1 as trustee_1,
  custom_zen_desk_case_link as zendesk_case_link,
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
{% if var('restatements_project_ids') %}
where
    project_id in (
{{ var('restatements_project_ids') | join (", ") }}
)
{% endif %}

--add custom field pass throughs
