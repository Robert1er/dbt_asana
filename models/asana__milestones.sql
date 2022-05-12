with projects as (

    select
        project_id

    from {{ ref('stg_asana__project') }}
    where team_id = '1170823813530401'
),

tasks as (

    select
        project_task.project_id,
        task_tag.tag_id,
        task.due_date,
        task.completed_at

    from {{ ref('stg_asana__project_task') }} project_task
    join {{ ref('stg_asana__task') }} task on project_task.task_id = task.task_id
    join {{ ref('stg_asana__task_tag') }} task_tag on task_tag.task_id = task.task_id

    where /*task._fivetran_deleted = False
        and*/ task_tag.tag_id in (
            '1200479848126729', --m0
            '1200400519729715', --m1
            '1200400519729724', --m2
            '1200400519729737', --m3
            '1200400519729734', --m3_inv
            '1200400519729736', --m3_is_elig
            '1200400519729735', --m3_rm_elig
            '1200400519729740', --m3_rm_rem
            '1200400519729738', --m4
            '1200400519729739', --m4_send_data
            '1200400519729743' --m5
        )
),

m0 as (

    select
        project_id,
        min(completed_at) as completed_at

    from tasks
    where tag_id = '1200479848126729'
    {{ dbt_utils.group_by(1) }}
),

m1 as (

    select
        project_id,
        min(due_date) as due_on,
        min(completed_at) as completed_at

    from tasks
    where tag_id = '1200400519729715'
    {{ dbt_utils.group_by(1) }}
),

m2 as (

    select
        project_id,
        min(due_date) as due_on,
        min(completed_at) as completed_at

    from tasks
    where tag_id = '1200400519729724'
    {{ dbt_utils.group_by(1) }}
),

m3 as (

    select
        project_id,
        min(due_date) as due_on,
        min(completed_at) as completed_at

    from tasks
    where tag_id = '1200400519729737'
    {{ dbt_utils.group_by(1) }}
),

m3_inv as (

    select
        project_id,
        min(completed_at) as completed_at

    from tasks
    where tag_id = '1200400519729734'
    {{ dbt_utils.group_by(1) }}
),

m3_is_elig as (

    select
        project_id,
        min(completed_at) as completed_at

    from tasks
    where tag_id = '1200400519729736'
    {{ dbt_utils.group_by(1) }}
),

m3_rm_elig as (

    select
        project_id,
        min(completed_at) as completed_at

    from tasks
    where tag_id = '1200400519729735'
    {{ dbt_utils.group_by(1) }}
),

m3_rm_rem as (

    select
        project_id,
        min(completed_at) as completed_at

    from tasks
    where tag_id = '1200400519729740'
    {{ dbt_utils.group_by(1) }}
),

m4 as (

    select
        project_id,
        min(due_date) as due_on,
        min(completed_at) as completed_at

    from tasks
    where tag_id = '1200400519729738'
    {{ dbt_utils.group_by(1) }}
),

m4_send_data as (

    select
        project_id,
        min(completed_at) as completed_at

    from tasks
    where tag_id = '1200400519729739'
    {{ dbt_utils.group_by(1) }}
),

m5 as (

    select
        project_id,
        min(due_date) as due_on,
        min(completed_at) as completed_at

    from tasks
    where tag_id = '1200400519729743'
    {{ dbt_utils.group_by(1) }}
)

select
    projects.project_id,
    m0.completed_at as m0_done,
    m1.due_on as m1_due,
    m1.completed_at as m1_done,
    m2.due_on as m2_due,
    m2.completed_at as m2_done,
    m3.due_on as m3_due,
    m3.completed_at as m3_done,
    m3_inv.completed_at as m3_investments,
    m3_is_elig.completed_at as m3_is_final_elige_review,
    m3_rm_elig.completed_at as m3_rm_eligibility_review,
    m3_rm_rem.completed_at as m3_remainder,
    m4.due_on as m4_due,
    m4.completed_at as m4_done,
    m4_send_data.completed_at as m4_sent,
    m5.due_on as m5_due,
    m5.completed_at as m5_done,

    --go from m0 to m5, the current milestone is the milestone corresponding to the first non-null completed_at value, else null (current milestone has added logic in the outermost query below)
    case
        when m0.completed_at is null
            then 'M0'
        when m1.completed_at is null
            then 'M1'
        when m2.completed_at is null
            then 'M2'
        when m3.completed_at is null
            then 'M3'
        when m4.completed_at is null
            then 'M4'
        when m5.completed_at is null
            then 'M5'
    end current_milestone

from projects
left join m0 on m0.project_id = projects.project_id
left join m1 on m1.project_id = projects.project_id
left join m2 on m2.project_id = projects.project_id
left join m3 on m3.project_id = projects.project_id
left join m3_inv on m3_inv.project_id = projects.project_id
left join m3_is_elig on m3_is_elig.project_id = projects.project_id
left join m3_rm_elig on m3_rm_elig.project_id = projects.project_id
left join m3_rm_rem on m3_rm_rem.project_id = projects.project_id
left join m4 on m4.project_id = projects.project_id
left join m4_send_data on m4_send_data.project_id = projects.project_id
left join m5 on m5.project_id = projects.project_id
