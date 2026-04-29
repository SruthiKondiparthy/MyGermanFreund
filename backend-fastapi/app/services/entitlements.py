def get_subscription_state(user_id: str) -> dict[str, str | bool]:
    premium_users = {"demo-premium-user"}
    is_premium = user_id in premium_users
    return {
        "user_id": user_id,
        "premium": is_premium,
        "plan": "premium" if is_premium else "free",
    }
