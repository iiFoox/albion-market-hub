# HEPHAESTUS Health Report

---
log_type: "health"
timestamp: "2026-04-29T21:51:24.1497432-03:00"
status: "healthy"
framework_version: "8.7.0"
---

## Score

100/100 - HEALTHY

## Findings

- Integrity validation passed.
- Telemetry validation passed.
- LITE loading estimate passed.
- Session checkpoint exists.
- Telemetry logs found: 1.

## Validation Summary

### Integrity

```text
Level Check              Message                                                               
----- -----              -------                                                               
PASS  agent-contract     builder/AGENT.md                                                      
PASS  agent-contract     builder/capabilities.yaml                                             
PASS  agent-contract     delivery/AGENT.md                                                     
PASS  agent-contract     delivery/capabilities.yaml                                            
PASS  agent-contract     documentation/AGENT.md                                                
PASS  agent-contract     documentation/capabilities.yaml                                       
PASS  agent-contract     orchestrator/AGENT.md                                                 
PASS  agent-contract     orchestrator/capabilities.yaml                                        
PASS  agent-contract     planner/AGENT.md                                                      
PASS  agent-contract     planner/capabilities.yaml                                             
PASS  agent-contract     platform-guardian/AGENT.md                                            
PASS  agent-contract     platform-guardian/capabilities.yaml                                   
PASS  agent-contract     project-manager/AGENT.md                                              
PASS  agent-contract     project-manager/capabilities.yaml                                     
PASS  agent-contract     researcher/AGENT.md                                                   
PASS  agent-contract     researcher/capabilities.yaml                                          
PASS  agent-contract     ui-ux-specialist/AGENT.md                                             
PASS  agent-contract     ui-ux-specialist/capabilities.yaml                                    
PASS  agent-contract     validator/AGENT.md                                                    
PASS  agent-contract     validator/capabilities.yaml                                           
PASS  count              agents=10                                                             
PASS  count              docs_languages=2                                                      
PASS  count              memory_stores=4                                                       
PASS  count              protocols=36                                                          
PASS  count              workflows=12                                                          
PASS  required-directory .agents/agents                                                        
PASS  required-directory .agents/config                                                        
PASS  required-directory .agents/docs/_source                                                  
PASS  required-directory .agents/docs/en                                                       
PASS  required-directory .agents/docs/pt-br                                                    
PASS  required-directory .agents/kernel                                                        
PASS  required-directory .agents/memory/context-db                                             
PASS  required-directory .agents/memory/evolution-log                                          
PASS  required-directory .agents/memory/knowledge-graph                                        
PASS  required-directory .agents/memory/learning-store                                         
PASS  required-directory .agents/memory/templates                                              
PASS  required-directory .agents/protocols                                                     
PASS  required-directory .agents/releases                                                      
PASS  required-directory .agents/reports/adapters                                              
PASS  required-directory .agents/reports/communication                                         
PASS  required-directory .agents/reports/discovery                                             
PASS  required-directory .agents/reports/documentation                                         
PASS  required-directory .agents/reports/executions                                            
PASS  required-directory .agents/reports/health                                                
PASS  required-directory .agents/reports/loading                                               
PASS  required-directory .agents/reports/memory                                                
PASS  required-directory .agents/reports/operational                                           
PASS  required-directory .agents/reports/operator                                              
PASS  required-directory .agents/reports/releases                                              
PASS  required-directory .agents/reports/simulations                                           
PASS  required-directory .agents/tests/expected-routing                                        
PASS  required-directory .agents/tests/fixtures                                                
PASS  required-directory .agents/tools                                                         
PASS  required-directory .agents/workflows                                                     
PASS  required-file      .agents/AGENTS.md                                                     
PASS  required-file      .agents/config/agent-registry.yaml                                    
PASS  required-file      .agents/config/communication-bus.yaml                                 
PASS  required-file      .agents/config/documentation-policy.yaml                              
PASS  required-file      .agents/config/framework.yaml                                         
PASS  required-file      .agents/config/framework-manifest.yaml                                
PASS  required-file      .agents/config/loading-tiers.yaml                                     
PASS  required-file      .agents/config/memory-policy.yaml                                     
PASS  required-file      .agents/config/multi-project.yaml                                     
PASS  required-file      .agents/config/project.yaml                                           
PASS  required-file      .agents/config/project-discovery-policy.yaml                          
PASS  required-file      .agents/config/stability-baseline.yaml                                
PASS  required-file      .agents/config/telemetry-schema.yaml                                  
PASS  required-file      .agents/docs/_source/README.md                                        
PASS  required-file      .agents/docs/_translation-map.yaml                                    
PASS  required-file      .agents/docs/en/12-PROJECT-DISCOVERY.md                               
PASS  required-file      .agents/docs/en/13-REAL-PROJECT-ADAPTER.md                            
PASS  required-file      .agents/docs/en/14-REAL-PROJECT-EXECUTION.md                          
PASS  required-file      .agents/docs/en/15-COMMAND-QUALITY-GATES.md                           
PASS  required-file      .agents/docs/en/16-REAL-PROJECT-APPLY-SCENARIO.md                     
PASS  required-file      .agents/docs/en/17-DOCUMENTATION-RUNTIME-LOOP.md                      
PASS  required-file      .agents/docs/en/18-RELEASE-EVIDENCE-BUNDLE.md                         
PASS  required-file      .agents/docs/en/19-OPERATIONAL-SCORE-REVIEW.md                        
PASS  required-file      .agents/docs/en/20-INSTALL-UPDATE-WIZARD.md                           
PASS  required-file      .agents/docs/en/21-OPTIONAL-TELEMETRY-MEMORY-PROOF.md                 
PASS  required-file      .agents/docs/en/22-OPERATOR-EXPERIENCE-MAP.md                         
PASS  required-file      .agents/docs/en/23-INTER-AGENT-COMMUNICATION-BUS.md                   
PASS  required-file      .agents/docs/en/24-UNIFIED-OPERATOR-CLI.md                            
PASS  required-file      .agents/docs/en/25-CORE-CONTRACT-DRIFT-GUARD.md                       
PASS  required-file      .agents/docs/en/26-OPERATOR-DAILY-LAUNCHER.md                         
PASS  required-file      .agents/docs/en/27-PROJECT-BOOTSTRAP-ASSISTANT.md                     
PASS  required-file      .agents/docs/en/28-STABILITY-BASELINE.md                              
PASS  required-file      .agents/docs/en/29-OPERATOR-RUNBOOK-RECOVERY.md                       
PASS  required-file      .agents/docs/en/30-GUIDED-INSTALLER-REPOSITORY-ONBOARDING.md          
PASS  required-file      .agents/docs/en/31-PRACTICAL-FIRST-PROJECT-WALKTHROUGH.md             
PASS  required-file      .agents/docs/en/HEPHAESTUS-COMPLETE-REFERENCE.md                      
PASS  required-file      .agents/docs/en/README.md                                             
PASS  required-file      .agents/docs/pt-br/12-DESCOBERTA-DE-PROJETO.md                        
PASS  required-file      .agents/docs/pt-br/13-ADAPTADOR-DE-PROJETO-REAL.md                    
PASS  required-file      .agents/docs/pt-br/14-EXECUCAO-EM-PROJETO-REAL.md                     
PASS  required-file      .agents/docs/pt-br/15-COMANDOS-E-QUALITY-GATES.md                     
PASS  required-file      .agents/docs/pt-br/16-CENARIO-DE-APPLY-EM-PROJETO-REAL.md             
PASS  required-file      .agents/docs/pt-br/17-LOOP-DE-DOCUMENTACAO-RUNTIME.md                 
PASS  required-file      .agents/docs/pt-br/18-PACOTE-DE-EVIDENCIAS-DE-RELEASE.md              
PASS  required-file      .agents/docs/pt-br/19-REVISAO-DE-NOTA-OPERACIONAL.md                  
PASS  required-file      .agents/docs/pt-br/20-WIZARD-DE-INSTALACAO-E-UPDATE.md                
PASS  required-file      .agents/docs/pt-br/21-PROVA-OPCIONAL-DE-TELEMETRIA-E-MEMORIA.md       
PASS  required-file      .agents/docs/pt-br/22-MAPA-DE-EXPERIENCIA-DO-OPERADOR.md              
PASS  required-file      .agents/docs/pt-br/23-BARRAMENTO-DE-COMUNICACAO-ENTRE-AGENTES.md      
PASS  required-file      .agents/docs/pt-br/24-CLI-UNIFICADO-DO-OPERADOR.md                    
PASS  required-file      .agents/docs/pt-br/25-GUARDA-DE-DERIVA-DO-CONTRATO-CENTRAL.md         
PASS  required-file      .agents/docs/pt-br/26-LANCADOR-DIARIO-DO-OPERADOR.md                  
PASS  required-file      .agents/docs/pt-br/27-ASSISTENTE-DE-BOOTSTRAP-DE-PROJETO.md           
PASS  required-file      .agents/docs/pt-br/28-BASELINE-DE-ESTABILIDADE.md                     
PASS  required-file      .agents/docs/pt-br/29-RUNBOOK-E-RECUPERACAO-DO-OPERADOR.md            
PASS  required-file      .agents/docs/pt-br/30-INSTALADOR-GUIADO-E-ONBOARDING-DE-REPOSITORIO.md
PASS  required-file      .agents/docs/pt-br/31-PASSO-A-PASSO-PRATICO-DO-PRIMEIRO-PROJETO.md    
PASS  required-file      .agents/docs/pt-br/HEPHAESTUS-COMPLETE-REFERENCE.md                   
PASS  required-file      .agents/docs/pt-br/README.md                                          
PASS  required-file      .agents/docs/README.md                                                
PASS  required-file      .agents/kernel/COMPATIBILITY.md                                       
PASS  required-file      .agents/kernel/HOST-MATRIX.md                                         
PASS  required-file      .agents/kernel/INSTALL-UPDATE.md                                      
PASS  required-file      .agents/kernel/KERNEL.md                                              
PASS  required-file      .agents/kernel/MIGRATION-v5-to-v6.md                                  
PASS  required-file      .agents/memory/context-db/next-chat-activation-prompt.md              
PASS  required-file      .agents/memory/context-db/session-brief.md                            
PASS  required-file      .agents/memory/context-db/session-checkpoint.md                       
PASS  required-file      .agents/memory/MEMORY.md                                              
PASS  required-file      .agents/memory/MEMORY-INDEX.md                                        
PASS  required-file      .agents/memory/templates/decision.md                                  
PASS  required-file      .agents/memory/templates/learning.md                                  
PASS  required-file      .agents/memory/templates/next-action.md                               
PASS  required-file      .agents/memory/templates/project-state.md                             
PASS  required-file      .agents/memory/templates/risk.md                                      
PASS  required-file      .agents/protocols/command-allowlist-quality-gate-protocol.md          
PASS  required-file      .agents/protocols/core-contract-drift-guard-protocol.md               
PASS  required-file      .agents/protocols/developer-real-project-execution-protocol.md        
PASS  required-file      .agents/protocols/documentation-enforcement-protocol.md               
PASS  required-file      .agents/protocols/documentation-runtime-loop-protocol.md              
PASS  required-file      .agents/protocols/final-operator-experience-review-protocol.md        
PASS  required-file      .agents/protocols/guided-installer-repository-onboarding-protocol.md  
PASS  required-file      .agents/protocols/install-update-wizard-protocol.md                   
PASS  required-file      .agents/protocols/inter-agent-communication-bus-protocol.md           
PASS  required-file      .agents/protocols/operational-polish-score-review-protocol.md         
PASS  required-file      .agents/protocols/operator-daily-launcher-protocol.md                 
PASS  required-file      .agents/protocols/operator-runbook-recovery-protocol.md               
PASS  required-file      .agents/protocols/optional-telemetry-memory-proof-protocol.md         
PASS  required-file      .agents/protocols/practical-first-project-walkthrough-protocol.md     
PASS  required-file      .agents/protocols/project-bootstrap-assistant-protocol.md             
PASS  required-file      .agents/protocols/project-discovery-protocol.md                       
PASS  required-file      .agents/protocols/real-project-adapter-protocol.md                    
PASS  required-file      .agents/protocols/real-project-apply-scenario-protocol.md             
PASS  required-file      .agents/protocols/real-project-execution-hardening-protocol.md        
PASS  required-file      .agents/protocols/release-evidence-bundle-protocol.md                 
PASS  required-file      .agents/protocols/stability-baseline-regression-sentinel-protocol.md  
PASS  required-file      .agents/protocols/unified-operator-cli-protocol.md                    
PASS  required-file      .agents/releases/CHANGELOG.md                                         
PASS  required-file      .agents/releases/PACKAGE-CHECKLIST.md                                 
PASS  required-file      .agents/releases/v5.1.0.md                                            
PASS  required-file      .agents/releases/v5.2.0.md                                            
PASS  required-file      .agents/releases/v5.3.0.md                                            
PASS  required-file      .agents/releases/v5.4.0.md                                            
PASS  required-file      .agents/releases/v5.5.0.md                                            
PASS  required-file      .agents/releases/v5.6.0.md                                            
PASS  required-file      .agents/releases/v5.7.0.md                                            
PASS  required-file      .agents/releases/v5.8.0.md                                            
PASS  required-file      .agents/releases/v6.0.0.md                                            
PASS  required-file      .agents/releases/v6.1.0.md                                            
PASS  required-file      .agents/releases/v6.2.0.md                                            
PASS  required-file      .agents/releases/v6.3.0.md                                            
PASS  required-file      .agents/releases/v6.4.0.md                                            
PASS  required-file      .agents/releases/v6.5.0.md                                            
PASS  required-file      .agents/releases/v6.6.0.md                                            
PASS  required-file      .agents/releases/v6.7.0.md                                            
PASS  required-file      .agents/releases/v6.8.0.md                                            
PASS  required-file      .agents/releases/v6.9.0.md                                            
PASS  required-file      .agents/releases/v7.0.0.md                                            
PASS  required-file      .agents/releases/v7.1.0.md                                            
PASS  required-file      .agents/releases/v7.2.0.md                                            
PASS  required-file      .agents/releases/v7.3.0.md                                            
PASS  required-file      .agents/releases/v7.4.0.md                                            
PASS  required-file      .agents/releases/v7.5.0.md                                            
PASS  required-file      .agents/releases/v7.6.0.md                                            
PASS  required-file      .agents/releases/v7.7.0.md                                            
PASS  required-file      .agents/releases/v7.8.0.md                                            
PASS  required-file      .agents/releases/v7.9.0.md                                            
PASS  required-file      .agents/releases/v8.0.0.md                                            
PASS  required-file      .agents/releases/v8.1.0.md                                            
PASS  required-file      .agents/releases/v8.2.0.md                                            
PASS  required-file      .agents/releases/v8.3.0.md                                            
PASS  required-file      .agents/releases/v8.4.0.md                                            
PASS  required-file      .agents/releases/v8.5.0.md                                            
PASS  required-file      .agents/releases/v8.6.0.md                                            
PASS  required-file      .agents/releases/v8.7.0.md                                            
PASS  required-file      .agents/reports/adapters/project-bootstrap-template.md                
PASS  required-file      .agents/reports/adapters/README.md                                    
PASS  required-file      .agents/reports/adapters/real-project-adapter-status-template.md      
PASS  required-file      .agents/reports/communication/communication-bus-template.md           
PASS  required-file      .agents/reports/communication/README.md                               
PASS  required-file      .agents/reports/discovery/decision-log-template.md                    
PASS  required-file      .agents/reports/discovery/project-discovery-template.md               
PASS  required-file      .agents/reports/discovery/README.md                                   
PASS  required-file      .agents/reports/documentation/documentation-impact-template.md        
PASS  required-file      .agents/reports/documentation/documentation-runtime-report-template.md
PASS  required-file      .agents/reports/documentation/README.md                               
PASS  required-file      .agents/reports/executions/command-quality-gate-report-template.md    
PASS  required-file      .agents/reports/executions/README.md                                  
PASS  required-file      .agents/reports/executions/real-project-apply-scenario-template.md    
PASS  required-file      .agents/reports/executions/real-project-execution-plan-template.md    
PASS  required-file      .agents/reports/executions/real-project-hardening-template.md         
PASS  required-file      .agents/reports/health/README.md                                      
PASS  required-file      .agents/reports/loading/README.md                                     
PASS  required-file      .agents/reports/memory/memory-proof-template.md                       
PASS  required-file      .agents/reports/memory/README.md                                      
PASS  required-file      .agents/reports/operational/README.md                                 
PASS  required-file      .agents/reports/operational/score-review-template.md                  
PASS  required-file      .agents/reports/operational/stability-baseline-template.md            
PASS  required-file      .agents/reports/operator/operator-experience-template.md              
PASS  required-file      .agents/reports/operator/README.md                                    
PASS  required-file      .agents/reports/operator/repository-setup-latest.md                   
PASS  required-file      .agents/reports/releases/README.md                                    
PASS  required-file      .agents/reports/releases/release-evidence-template.md                 
PASS  required-file      .agents/reports/simulations/README.md                                 
PASS  required-file      .agents/tests/expected-routing/README.md                              
PASS  required-file      .agents/tools/check-agent-mastery.ps1                                 
PASS  required-file      .agents/tools/check-command-allowlist.ps1                             
PASS  required-file      .agents/tools/check-communication-bus.ps1                             
PASS  required-file      .agents/tools/check-core-contract.ps1                                 
PASS  required-file      .agents/tools/check-doc-parity.ps1                                    
PASS  required-file      .agents/tools/check-documentation-enforcement.ps1                     
PASS  required-file      .agents/tools/check-documentation-runtime-loop.ps1                    
PASS  required-file      .agents/tools/check-first-project-walkthrough.ps1                     
PASS  required-file      .agents/tools/check-guided-installer.ps1                              
PASS  required-file      .agents/tools/check-install-update-wizard.ps1                         
PASS  required-file      .agents/tools/check-kernel-contract.ps1                               
PASS  required-file      .agents/tools/check-memory-proof.ps1                                  
PASS  required-file      .agents/tools/check-operational-score-review.ps1                      
PASS  required-file      .agents/tools/check-operator-daily-launcher.ps1                       
PASS  required-file      .agents/tools/check-operator-experience.ps1                           
PASS  required-file      .agents/tools/check-operator-runbook.ps1                              
PASS  required-file      .agents/tools/check-project-bootstrap.ps1                             
PASS  required-file      .agents/tools/check-project-discovery.ps1                             
PASS  required-file      .agents/tools/check-real-project-adapter.ps1                          
PASS  required-file      .agents/tools/check-real-project-apply-scenario.ps1                   
PASS  required-file      .agents/tools/check-real-project-execution.ps1                        
PASS  required-file      .agents/tools/check-real-project-hardening.ps1                        
PASS  required-file      .agents/tools/check-release-evidence-bundle.ps1                       
PASS  required-file      .agents/tools/check-stability-baseline.ps1                            
PASS  required-file      .agents/tools/check-unified-cli.ps1                                   
PASS  required-file      .agents/tools/cleanup-telemetry.ps1                                   
PASS  required-file      .agents/tools/compare-framework-version.ps1                           
PASS  required-file      .agents/tools/estimate-loading.ps1                                    
PASS  required-file      .agents/tools/framework-health.ps1                                    
PASS  required-file      .agents/tools/hephaestus.ps1                                          
PASS  required-file      .agents/tools/install-framework.ps1                                   
PASS  required-file      .agents/tools/install-hephaestus.bat                                  
PASS  required-file      .agents/tools/install-hephaestus-launcher.ps1                         
PASS  required-file      .agents/tools/operator-daily.ps1                                      
PASS  required-file      .agents/tools/pre-release-gate.ps1                                    
PASS  required-file      .agents/tools/run-communication-bus-proof.ps1                         
PASS  required-file      .agents/tools/run-developer-benchmark.ps1                             
PASS  required-file      .agents/tools/run-developer-execution-simulation.ps1                  
PASS  required-file      .agents/tools/run-documentation-runtime-loop.ps1                      
PASS  required-file      .agents/tools/run-framework-simulation.ps1                            
PASS  required-file      .agents/tools/run-memory-proof.ps1                                    
PASS  required-file      .agents/tools/run-operational-score-review.ps1                        
PASS  required-file      .agents/tools/run-operator-experience-review.ps1                      
PASS  required-file      .agents/tools/run-project-bootstrap.ps1                               
PASS  required-file      .agents/tools/run-quality-gates.ps1                                   
PASS  required-file      .agents/tools/run-real-project-execution.ps1                          
PASS  required-file      .agents/tools/run-release-evidence-bundle.ps1                         
PASS  required-file      .agents/tools/run-stability-baseline.ps1                              
PASS  required-file      .agents/tools/test-developer-benchmark.ps1                            
PASS  required-file      .agents/tools/test-developer-execution-mode.ps1                       
PASS  required-file      .agents/tools/test-documentation-runtime-loop.ps1                     
PASS  required-file      .agents/tools/test-installation-tools.ps1                             
PASS  required-file      .agents/tools/test-quality-gate-runner.ps1                            
PASS  required-file      .agents/tools/test-real-project-apply-scenario.ps1                    
PASS  required-file      .agents/tools/test-real-project-execution.ps1                         
PASS  required-file      .agents/tools/test-release-evidence-bundle.ps1                        
PASS  required-file      .agents/tools/test-routing.ps1                                        
PASS  required-file      .agents/tools/test-simulation-harness.ps1                             
PASS  required-file      .agents/tools/update-framework.ps1                                    
PASS  required-file      .agents/tools/validate-framework.ps1                                  
PASS  required-file      .agents/tools/validate-telemetry.ps1                                  
PASS  required-file      .agents/workflows/project-discovery-workflow.md                       
PASS  required-file      .agents/workflows/real-project-adapter-workflow.md                    
PASS  required-file      .agents/workflows/real-project-execution-workflow.md                  
PASS  version            .agents/AGENTS.md contains 8.7.0                                      
PASS  version            .agents/config/agent-registry.yaml contains 8.7.0                     
PASS  version            .agents/config/framework.yaml contains 8.7.0                          
PASS  version            .agents/docs/en/README.md contains 8.7.0                              
PASS  version            .agents/docs/pt-br/README.md contains 8.7.0                           
PASS  version            .agents/docs/README.md contains 8.7.0                                 



Summary: PASS=289
```

### Telemetry

```text
Level Check     Message                                                    
----- -----     -------                                                    
PASS  logs      Found 1 telemetry log(s)                                   
PASS  timestamp .agents\telemetry\logs\pilot-run-2026-04-23.md timestamp ok



Summary: PASS=2
```

### Loading

```text
Tier              : lite
ConditionalGroups : (none)
Files             : 12
ExistingFiles     : 12
MissingFiles      : 0
Bytes             : 89897
ApproxTokens      : 22475
```
