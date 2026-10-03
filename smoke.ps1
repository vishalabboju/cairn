$ErrorActionPreference = "Continue"
$s = New-Object Microsoft.PowerShell.Commands.WebRequestSession
function Post($path, $body) { Invoke-RestMethod -Uri "http://localhost:3000$path" -Method Post -WebSession $s -ContentType "application/json" -Body ($body | ConvertTo-Json -Depth 6) }
function Get($path) { Invoke-RestMethod -Uri "http://localhost:3000$path" -Method Get -WebSession $s }
$ts = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$email = "smoke$ts@cairn.app"
$r = Post "/api/auth/register" @{name="Smoke"; email=$email; password="Test@1234"}; Write-Output "REGISTER: $($r.id)"
$me = Get "/api/auth/me"; Write-Output "ME: $($me.user.email)"
Invoke-RestMethod -Uri "http://localhost:3000/api/me" -Method Patch -WebSession $s -ContentType "application/json" -Body '{"educationLevel":"Undergraduate","goalState":"UNKNOWN"}' | Out-Null
Invoke-RestMethod -Uri "http://localhost:3000/api/me/interests" -Method Put -WebSession $s -ContentType "application/json" -Body '{"interestSlugs":["data","technology"],"hobbies":"chess"}' | Out-Null
Invoke-RestMethod -Uri "http://localhost:3000/api/me/skills" -Method Put -WebSession $s -ContentType "application/json" -Body '{"skills":[{"slug":"python","rating":2},{"slug":"sql","rating":1}]}' | Out-Null
Write-Output "ONBOARDING SAVED"
$start = Post "/api/assessment/start" @{}; Write-Output "ATTEMPT: $($start.attemptId) Qs: $($start.questions.Count)"
foreach ($q in $start.questions) { Post "/api/assessment/$($start.attemptId)/answer" @{questionId=$q.id; selected=0} | Out-Null }
$fin = Post "/api/assessment/$($start.attemptId)/finish" @{}; Write-Output "FINISH recs: $($fin.recommendations.Count)"
$g = Post "/api/goals" @{careerSlug="data-scientist"}; Write-Output "GOAL: $($g.goal.title)"
$gap = Get "/api/gap"; Write-Output "GAP match=$($gap.match) biggest=$($gap.biggestGap.skillName)"
$gen = Post "/api/roadmap/generate" @{}; Write-Output "ROADMAP v$($gen.version)"
$rm = Get "/api/roadmap"; Write-Output "ITEMS: $($rm.roadmap.items.Count) progress=$($rm.roadmap.progress)"
$first = @($rm.roadmap.items | Where-Object { $_.status -ne "DONE" })[0]
Invoke-RestMethod -Uri "http://localhost:3000/api/roadmap/items/$($first.id)" -Method Patch -WebSession $s -ContentType "application/json" -Body '{"status":"DONE"}' | Out-Null; Write-Output "ITEM DONE: $($first.title)"
$re = Post "/api/roadmap/reassess" @{}; Write-Output "REASSESS: $($re.message) match=$($re.match)"
$dash = Get "/api/dashboard"; Write-Output "DASH: $($dash.greeting) progress=$($dash.progress) next=$($dash.nextStep.title)"
$projs = Get "/api/projects?career=data-scientist"; $projId = $projs.projects[0].id; Write-Output "PROJECT: $($projs.projects[0].title)"
$sub = Post "/api/projects/$projId/submit" @{description="My analysis of the dataset with charts and findings."; githubUrl="https://github.com/smoke/demo"}; Write-Output "SUBMITTED: $($sub.submission.id)"
$ach = Get "/api/achievements"; $earned = @($ach.achievements | Where-Object { $_.earned }).Count; Write-Output "ACHIEVEMENTS earned: $earned / $($ach.achievements.Count)"
$opps = Get "/api/opportunities"; Write-Output "OPPS: $($opps.opportunities.Count) first=$($opps.opportunities[0].title) match=$($opps.opportunities[0].matchText)"
$oid = $opps.opportunities[0].id
Post "/api/opportunities/$oid/save" @{} | Out-Null; Post "/api/opportunities/$oid/apply" @{} | Out-Null
$cg = Post "/api/opportunities/$oid/close-gap" @{}; Write-Output "CLOSEGAP: $($cg.message)"
$pw = Get "/api/pathways"; Write-Output "PATHWAYS: $($pw.pathways.Count) top=$($pw.pathways[0].title) overlap=$($pw.pathways[0].overlap)"
$piv = Post "/api/goals/pivot" @{newCareerSlug="data-analyst"}; Write-Output "PIVOT carry=$($piv.carryOver.Count) new=$($piv.newSkills.Count)"
$men = Post "/api/mentor" @{message="I have 6 weeks before internship applications. What should I focus on?"}; Write-Output "MENTOR mode=$($men.mode) plan=$($men.suggestedPlan.Count)"
Post "/api/feedback" @{surface="smoke"; useful=$true; comment="great"} | Out-Null; Write-Output "FEEDBACK ok"
$port = Get "/api/portfolio"; Write-Output "PORTFOLIO projects=$($port.portfolio.projects.Count)"
# guest endpoints
Invoke-RestMethod -Uri "http://localhost:3000/api/careers" | ForEach-Object { Write-Output "GUEST careers: $($_.careers.Count)" }
Invoke-RestMethod -Uri "http://localhost:3000/api/careers/compare?slugs=data-scientist,data-analyst" | ForEach-Object { Write-Output "GUEST compare: $($_.compare.Count)" }
Write-Output "SMOKE COMPLETE"
