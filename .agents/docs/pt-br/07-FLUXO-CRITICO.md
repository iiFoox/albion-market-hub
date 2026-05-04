# 07 — Fluxo Crítico (CRITICAL)

> **Nível:** 🔴 Expert  
> **Complexidade:** CRITICAL  
> **Agentes ativos:** TODOS, sem exceção  
> **Quando usar:** Produção com dados reais, financeiro, saúde, compliance, rollback difícil

---

## Quando é CRITICAL

| Cenário | Por que é CRITICAL |
|---------|-------------------|
| Integração de pagamento (Stripe, PagSeguro) | Dados financeiros, PCI-DSS |
| Deploy em produção | Dados reais de usuários |
| Migração de banco em produção | Rollback pode ser impossível |
| Sistema de saúde | HIPAA, dados sensíveis |
| LGPD/GDPR compliance | Regulatório, multas |
| Criptografia e segurança | Vulnerabilidade = breach |

---

## O que muda no CRITICAL

| Aspecto | STANDARD | CRITICAL |
|---------|----------|----------|
| Agentes | 5-6 | TODOS 10 |
| Deep reasoning | Builder + Validator | TODOS |
| Security audit | Básico | Completo (OWASP Top 10) |
| Red team | Não | Builder + Validator |
| Memory query | Standard | Full + cross-project + incident archetypes |
| Industry profile | Se ativo | Obrigatório |
| Documentation | Changelog | Changelog + ADR + release notes |
| Version | Patch/minor | Minor/major + tag + release notes |
| Triage exclusão | Permitido | Proibido (todos participam) |

---

## Exemplo: Integração Stripe

### Seu prompt:
```markdown
CRITICAL: Implemente integração Stripe para pagamento de assinaturas:

1. Checkout com cartão de crédito
2. Planos: Basic (R$29/mês), Pro (R$79/mês), Enterprise (R$199/mês)
3. Trial de 14 dias
4. Webhook para processar eventos (payment_succeeded, subscription_cancelled)
5. Portal do cliente para gerenciar assinatura
6. Downgrade/upgrade de plano
7. Tratamento de falha de pagamento (retry, notificação)

Plataformas: Android + Web (Windows não precisa de pagamento)
Backend: API Node.js/Express já existente
LGPD: dados de pagamento NÃO são armazenados localmente

Preciso de:
- Plano faseado com rollback strategy
- Security audit completo
- Compliance check (PCI-DSS, LGPD)
- Test coverage mínimo 90%
```

### Security Audit do Validator (modo CRITICAL):
```
🔒 SECURITY AUDIT — PAYMENT INTEGRATION

1. PCI-DSS Compliance:
   ✅ Stripe Elements/SDK usa tokenização (dados do cartão nunca tocam nosso server)
   ✅ Nenhum número de cartão armazenado localmente
   ✅ Webhook signature verification implementado
   ⚠️ Webhook endpoint precisa de rate limiting
   ⚠️ API keys devem estar em variáveis de ambiente, nunca no código

2. OWASP Top 10 Review:
   ✅ A01 Broken Access Control: Verificação de permissão em endpoints de billing
   ✅ A02 Cryptographic Failures: HTTPS obrigatório, sem dados sensíveis em logs
   ⚠️ A03 Injection: Sanitizar metadata de assinatura antes de persistir
   ✅ A07 Auth Failures: Webhook usa signature verification
   ❌ A09 Security Logging: Faltam logs de auditoria para operações financeiras

3. LGPD Check:
   ✅ Dados de pagamento processados via Stripe (controller/processor adequado)
   ✅ Consentimento coletado antes do primeiro pagamento
   ⚠️ Missing: data retention policy para invoices
   ⚠️ Missing: user data export inclui dados de billing?

VEREDICTO: NEEDS_CHANGES (1 crítico, 4 avisos)
```

---

## Dica para Pedidos CRITICAL

```
CRITICAL: [descrição completa]

Checklist obrigatório:
□ Security audit (OWASP + específico do domínio)
□ Compliance check (LGPD/GDPR/PCI/HIPAA se aplicável)
□ Rollback strategy definida
□ Test coverage > 90%
□ Incident response plan
□ Monitoring/alerting configurado
□ Documentation completa (ADR + runbook)
```

---

## Próximo

→ [08-FLUXO-UI-UX.md](08-FLUXO-UI-UX.md) — Workflow especializado para UI
