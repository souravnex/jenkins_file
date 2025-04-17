pipeline {
    agent any

    environment {
        GIT_BRANCH = "main"     // Replace with the branch you want to monitor
        CHECK_FOLDER = "oozie"           // Root folder to start recursive check
    }

    triggers {
        gitlab(
            triggerOnPush: true,
            triggerOnMergeRequest: false,
            branchFilterType: 'NameBasedFilter',
            includeBranchesSpec: "${GIT_BRANCH}"
        )
    }

    stages {

        stage('Clone Repository') {
            steps {
                echo "🔁 Cloning branch: ${GIT_BRANCH}"
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "*/${GIT_BRANCH}"]],
                    userRemoteConfigs: [[url: 'https://github.com/souravnex/jenkins_file.git']]
                ])
            }
        }

        stage('Validate SQL/JSON File Pairs') {
            steps {
                script {
                    echo "🔍 Validating folders in ${CHECK_FOLDER}..."

                    sh """
                    has_issue=0

                    find "${CHECK_FOLDER}" -type d | while read folder; do
                        sql_count=\$(find "\$folder" -maxdepth 1 -type f -iname "*.sql" | wc -l)
                        json_count=\$(find "\$folder" -maxdepth 1 -type f -iname "*.json" | wc -l)

                        if [ "\$sql_count" -gt 0 ]; then
                            if [ "\$json_count" -gt 0 ]; then
                                echo "✅ OK: Found .sql and .json in: \$folder"
                            else
                                echo "❌ ERROR: Found .sql in \$folder but NO .json"
                                has_issue=1
                            fi
                        fi
                    done

                    if [ "\$has_issue" -eq 1 ]; then
                        echo "❗ Validation failed: Some folders with .sql files are missing .json files."
                        exit 1
                    else
                        echo "🎉 Validation successful: All folders with .sql files have .json files."
                    fi
                    """
                }
            }
        }

        stage('SQL Linting') {
            steps {
                script {
                    echo "🔍 Running SQL linting on each .sql file..."

                    sh """
                    has_sql_issue=0

                    find "${CHECK_FOLDER}" -type d | while read folder; do
                        find "\$folder" -maxdepth 1 -type f -iname "*.sql" | while read sqlfile; do
                            echo "🔎 Checking SQL syntax: \$sqlfile"
                            sqlite3 :memory: < "\$sqlfile" 2> lint_error.txt

                            if [ \$? -ne 0 ]; then
                                echo "❌ Lint failed for: \$sqlfile"
                                cat lint_error.txt
                                has_sql_issue=1
                            else
                                echo "✅ SQL OK: \$sqlfile"
                            fi
                        done
                    done

                    if [ "\$has_sql_issue" -eq 1 ]; then
                        echo "❗ Some SQL files failed linting."
                        exit 1
                    else
                        echo "🎉 All SQL files passed linting."
                    fi
                    """
                }
            }
        }

        stage('JSON Validation') {
            steps {
                script {
                    echo "📦 Validating JSON syntax using jq..."

                    sh """
                    has_json_issue=0

                    find "${CHECK_FOLDER}" -type d | while read folder; do
                        find "\$folder" -maxdepth 1 -type f -iname "*.json" | while read jsonfile; do
                            echo "🔍 Validating JSON: \$jsonfile"
                            jq empty "\$jsonfile" 2> json_error.txt

                            if [ \$? -ne 0 ]; then
                                echo "❌ Invalid JSON: \$jsonfile"
                                cat json_error.txt
                                has_json_issue=1
                            else
                                echo "✅ JSON OK: \$jsonfile"
                            fi
                        done
                    done

                    if [ "\$has_json_issue" -eq 1 ]; then
                        echo "❗ Some JSON files are invalid."
                        exit 1
                    else
                        echo "🎉 All JSON files passed validation."
                    fi
                    """
                }
            }
        }
    }

    post {
        failure {
            echo "🚨 Pipeline failed due to validation or linting errors."
        }
        success {
            echo "✅ Pipeline passed successfully."
        }
    }
}
